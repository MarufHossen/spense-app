import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:spense_app/base/data/state/states.dart';
import 'package:spense_app/base/widget/central_empty_list_placeholder.dart';
import 'package:spense_app/base/widget/central_error_placeholder.dart';
import 'package:spense_app/base/widget/central_progress_indicator.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/ui/shop/view/shop_controller.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:spense_app/util/lib/toast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../constants.dart';

class ShopPage extends GetView<ShopPageController> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: colorPageBackground,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (PreferenceUtil.on.read<bool>(
                keyIsLoggedIn,
                defaultValue: false,
              )!)
                buildInformationSection(),
              buildTitleSection(),
              Obx(
                () {
                  switch (controller.uiState.value) {
                    case UiState.onInitialization:
                    case UiState.onResult:
                      return buildPackageList();

                    case UiState.onResultEmpty:
                      return CentralEmptyListPlaceholder();

                    case UiState.onError:
                      return CentralErrorPlaceholder(
                        message: TextUtil.isNotEmpty(controller.errorMessage)
                            ? controller.errorMessage!
                            : defaultString,
                      );

                    case UiState.onLoading:
                    default:
                      return CentralProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInformationSection() {
    return GetBuilder<ShopPageController>(
      id: "user_information",
      init: ShopPageController(),
      builder: (_) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/ic_level.png",
                      fit: BoxFit.fitHeight,
                      height: 28.0,
                    ).marginOnly(right: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Level",
                          style: textStyleRegular.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          controller
                              .getCurrentLevel(
                                PreferenceUtil.on.read<int>(
                                  keyTotalEarnedPoints,
                                  defaultValue: 1,
                                )!,
                              )
                              .toString(),
                          style: textStyleRegular,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                decoration: const BoxDecoration(
                  color: colorGem,
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(18.0),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "images/ic_gem.png",
                      fit: BoxFit.fitHeight,
                      height: 16.0,
                    ).marginOnly(right: 8.0),
                    Text(
                      "${PreferenceUtil.on.read<int>(
                        keyGems,
                        defaultValue: 0,
                      )}",
                      style: textStyleRegular.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: colorCoin,
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(18.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "images/ic_coin.png",
                      fit: BoxFit.fitHeight,
                      height: 16.0,
                    ).marginOnly(right: 8.0),
                    Text(
                      "${PreferenceUtil.on.read<int>(
                        keyCoins,
                        defaultValue: 0,
                      )}",
                      style: textStyleRegular.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container buildTitleSection() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      child: Text(
        "Store".toUpperCase(),
        style: textStyleExtraExtraLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Expanded buildPackageList() {
    return Expanded(
      child: Obx(() {
        return StaggeredGridView.countBuilder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          crossAxisCount: 2,
          itemCount: controller.availableProductList.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return buildItem(
              controller.availableProductList[index],
              index,
            );
          },
          staggeredTileBuilder: (int index) {
            return StaggeredTile.fit(1);
          },
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        );
      }),
    );
  }

  Widget buildItem(ProductDetails data, int index) {
    return GestureDetector(
      onTap: () {
        if (PreferenceUtil.on.read<bool>(
          keyIsLoggedIn,
          defaultValue: false,
        )!) {
          controller.purchaseProduct(data);
        } else {
          ToastUtil.show("Log in to buy products from store");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
          border: const Border.fromBorderSide(
            const BorderSide(color: colorPrimary),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              (data.title.trim().toLowerCase().contains("gem"))
                  ? "images/ic_gem.png"
                  : "images/ic_coin.png",
              height: 32.0,
              fit: BoxFit.fitHeight,
            ),
            Text(
              data.title
                  .substring(
                    0,
                    data.title.indexOf('('),
                  )
                  .trim(),
              style: textStyleLarge,
              textAlign: TextAlign.start,
            ).marginSymmetric(vertical: 10.0),
            Text(
              data.price,
              style: textStyleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colorAccent,
              ),
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }
}
