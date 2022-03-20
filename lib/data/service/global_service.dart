import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';

const Set<String> _productIds = <String>{
  'id1_coins100',
  'id2_gems100',
  //'android.test.purchased',
};

class GlobalService extends GetxService {
  late InAppPurchase _inAppPurchase;
  late Stream<List<PurchaseDetails>> purchaseUpdated;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void onInit() {
    Get.log(
        "InAppPurchase.instance is initialized : ${InAppPurchase.instance != null}");
    _inAppPurchase = InAppPurchase.instance;

    purchaseUpdated = _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // handle error here.
        Get.log("Error : $error");
      },
    );

    initStoreInfo();

    super.onInit();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    Get.log("initStoreInfo() > Is store available? : $isAvailable");

    if (!isAvailable) {
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_productIds);

    if (productDetailResponse.error != null) {
      Get.log(
          "initStoreInfo() > Error : ${productDetailResponse.error!.message}");
      Get.log(
          "initStoreInfo() > Not found IDs : ${productDetailResponse.notFoundIDs.toString()}");
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      Get.log("initStoreInfo() > Found products : Empty");
      return;
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(
      (PurchaseDetails purchaseDetails) async {
        Get.log(
            "_listenToPurchaseUpdated() > Purchase details :: Purchase ID : ${purchaseDetails.purchaseID}");
        Get.log(
            "_listenToPurchaseUpdated() > Purchase details :: Product ID : ${purchaseDetails.productID}");
        Get.log(
            "_listenToPurchaseUpdated() > Purchase details :: Transaction date : ${purchaseDetails.transactionDate}");
        Get.log(
            "_listenToPurchaseUpdated() > Purchase details :: Status : ${purchaseDetails.status.toString().split('.').last}");
      },
    );
  }

  @override
  void onClose() {
    super.onClose();

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }

    _subscription.cancel();
  }
}
