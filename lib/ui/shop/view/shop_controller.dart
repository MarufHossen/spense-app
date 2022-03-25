import 'dart:async';
import 'dart:io';

import 'package:spense_app/base/data/state/states.dart';
import 'package:spense_app/base/exception/app_exception.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/local/local_service.dart';
import 'package:spense_app/data/remote/model/product/product.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:spense_app/util/lib/toast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';

const isAutoConsumptionEnabled = true;

class ShopPageController extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  late Rx<UiState> uiState;
  late String? errorMessage;
  late RxList<ProductDetails> availableProductList;
  late List<PurchaseDetails> purchaseDetailsList;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late LocalService _localService;

  @override
  void onInit() {
    super.onInit();
    uiState = UiState.onInitialization.obs;
    errorMessage = null;
    availableProductList = RxList();
    purchaseDetailsList = [];
    _localService = Get.find<LocalService>();

    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseData,
      onDone: _onPurchaseDone,
      onError: _onPurchaseError,
    );
  }

  @override
  void onReady() {
    _getInAppProductsFromBackend();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }

    availableProductList.close();
    _subscription.cancel();
  }

  Future<void> _getInAppProductsFromBackend() async {
    try {
      uiState.value = UiState.onLoading;
      final response = await RemoteRepository.on().getInAppProducts();

      if (response.isSuccessful && response.items.isNotEmpty) {
        Get.find<LocalService>().storeInAppProducts(response.items);
      }
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    } finally {
      _loadProductsForSale();
    }
  }

  int getCurrentLevel(int point) {
    return _localService.getCurrentLevel(point);
  }

  List<Product> getInAppProducts() {
    return _localService.getInAppProducts();
  }

  void _onPurchaseData(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(
      (
        PurchaseDetails details,
      ) async {
        Get.log(
          "InAppPurchase :: Purchase details :: Purchase ID : ${details.purchaseID}",
        );

        Get.log(
          "InAppPurchase :: Purchase details :: Product ID : ${details.productID}",
        );

        Get.log(
          "InAppPurchase :: Purchase details :: Transaction date : ${details.transactionDate}",
        );

        Get.log(
          "InAppPurchase :: Purchase details :: Status : ${details.status.toString().split('.').last}",
        );

        if (details.status == PurchaseStatus.pending) {
          // showPendingUI();
        } else {
          if (details.status == PurchaseStatus.error) {
            _onPurchaseStatusError(details.error!);
          } else if (details.status == PurchaseStatus.purchased ||
              details.status == PurchaseStatus.restored) {
            _deliverProduct(details);
          }

          if (details.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(details);
          }
        }
      },
    );
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    try {
      uiState.value = UiState.onLoading;

      final product = availableProductList.singleWhere(
        (productDetails) {
          return productDetails.id == purchaseDetails.productID;
        },
      );

      Get.log(
        "InAppPurchase :: Product found : ${product.toString()}",
      );

      final amount = int.tryParse(
        product.title.replaceAll(
          RegExp(r'[^0-9]'),
          defaultString,
        ),
      );

      Get.log(
        "InAppPurchase :: Amount found : ${amount.toString()}",
      );

      if (amount == null) {
        uiState.value = UiState.onResult;
        return;
      }

      final response = (product.title.trim().toLowerCase().contains("gem"))
          ? await RemoteRepository.on().incrementGem(amount)
          : await RemoteRepository.on().incrementCoin(amount);

      if (response.isSuccessful) {
        if (response.coins != null) {
          await PreferenceUtil.on.write<int>(
            keyCoins,
            response.coins!,
          );
        }

        if (response.gems != null) {
          await PreferenceUtil.on.write<int>(
            keyGems,
            response.gems!,
          );
        }

        if (response.totalEarnedPoints != null) {
          await PreferenceUtil.on.write<int>(
            keyTotalEarnedPoints,
            response.totalEarnedPoints!,
          );
        }

        update(["user_information"]);
        await _inAppPurchase.completePurchase(purchaseDetails);
        uiState.value = UiState.onResult;

        Get.log(
          "InAppPurchase :: Product delivery done : ${true}",
        );
      } else {
        if (TextUtil.isNotEmpty(response.message)) {
          ToastUtil.show(response.message);
        } else {
          ToastUtil.show("Could not deliver desired product");
        }

        uiState.value = UiState.onResult;
      }
    } catch (e) {
      if (e is AppException) {
        ToastUtil.show(e.toString());
      } else {
        ToastUtil.show("Could not deliver desired product");
      }

      uiState.value = UiState.onResult;
    }
  }

  void _onPurchaseStatusError(IAPError error) {
    Get.log(
      "InAppPurchase :: Purchase status error : ${(error.message.trim().isNotEmpty) ? error.message.trim() : 'no details '
          'found'}",
    );
  }

  void _onPurchaseDone() {
    Get.log(
      "InAppPurchase :: Purchase done : ${true}",
    );

    _subscription.cancel();
  }

  void _onPurchaseError(dynamic error) {
    Get.log(
      "InAppPurchase :: Purchase error : ${(error != null && error.toString().trim().isNotEmpty) ? error.toString().trim() : 'no details found'}",
    );

    uiState.value = UiState.onError;
    errorMessage = (error != null && error.toString().trim().isNotEmpty)
        ? error.toString().trim()
        : 'Unexpected error '
            'occurred while purchasing';
  }

  Future<void> purchaseProduct(ProductDetails productDetails) async {
    final purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: PreferenceUtil.on.read<int>(keyUserId)!.toString(),
    );

    _inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
      autoConsume: isAutoConsumptionEnabled || Platform.isIOS,
    );
  }

  Future<void> _loadProductsForSale() async {
    uiState.value = UiState.onLoading;

    final bool available = await _inAppPurchase.isAvailable();

    Get.log("InAppPurchase :: Store is available : $available");

    if (!available) {
      errorMessage = "The store could not be reached or accessed";
      uiState.value = UiState.onError;
    } else {
      try {
        if (Platform.isIOS) {
          var iosPlatformAddition = _inAppPurchase
              .getPlatformAddition<InAppPurchaseIosPlatformAddition>();
          await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
        }

        final response = await _inAppPurchase.queryProductDetails(
          getInAppProducts()
              .map(
                (item) => item.productId,
              )
              .toSet(),
        );

        Get.log(
          "InAppPurchase :: Product query response : ${response.toString()}",
        );

        if (response.error != null) {
          Get.log(
            "InAppPurchase :: Product query error (message) : ${response.error!.message}",
          );

          Get.log(
            "InAppPurchase :: Product query error (full) : ${response.error!.toString()}",
          );

          errorMessage = TextUtil.isNotEmpty(response.error!.message)
              ? response.error!.message.trim()
              : "Something went wrong";
          uiState.value = UiState.onError;
        }

        if (response.notFoundIDs.isNotEmpty) {
          Get.log(
            "InAppPurchase :: Product query error (not found ids) : ${response.notFoundIDs.toString()}",
          );

          errorMessage = "Could not find some products";
          uiState.value = UiState.onError;
        }

        List<ProductDetails> products = response.productDetails;

        if (products.isEmpty) {
          Get.log(
            "InAppPurchase :: Product query (verbose) : No product found",
          );

          uiState.value = UiState.onResultEmpty;
        } else {
          Get.log(
            "InAppPurchase :: Product query (verbose) : ${products.toString()}",
          );

          products.forEach(
            (element) {
              Get.log(
                "InAppPurchase :: Queried product (id) : ${element.id}",
              );
              Get.log(
                "InAppPurchase :: Queried product (title) : ${element.title}",
              );
              Get.log(
                "InAppPurchase :: Queried product (description) : ${element.description}",
              );
              Get.log(
                "InAppPurchase :: Queried product (price) : ${element.price}",
              );
              Get.log(
                "InAppPurchase :: Queried product (raw price) : ${element.rawPrice}",
              );
              Get.log(
                "InAppPurchase :: Queried product (currency code) : ${element.currencyCode}",
              );
              Get.log(
                "InAppPurchase :: Queried product (currency symbol) : ${element.currencySymbol}",
              );
            },
          );

          availableProductList.assignAll(products);
          uiState.value = UiState.onResult;
        }
      } catch (e) {
        Get.log(
          "InAppPurchase :: Error : ${TextUtil.isNotEmpty(e.toString().trim()) ? e.toString().trim() : 'Something went wrong'}",
        );

        errorMessage = TextUtil.isNotEmpty(e.toString().trim())
            ? e.toString().trim()
            : "Could not load products";
        uiState.value = UiState.onError;
      }
    }
  }
}

/// An implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implemented to provide information
/// needed to complete transactions.
class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
