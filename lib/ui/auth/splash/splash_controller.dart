import 'dart:async';

import 'package:flutter/services.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/local/local_service.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/ui/home/container/home_container.dart';
import 'package:spense_app/ui/home/container/home_container_binding.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void goToNextPage() {
    Get.offAll(
      () => HomeContainerPage(),
      binding: HomeContainerBinding(),
    );
  }

  @override
  void onInit() async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getAppEssentials();
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.onClose();
  }

  Future<void> getProfileData() async {
    try {
      final response = await RemoteRepository.on().getProfileData();

      if (response.isSuccessful) {
        if (response.coins != null) {
          await PreferenceUtil.on.write<int>(keyCoins, response.coins!);
        }

        if (response.gems != null) {
          await PreferenceUtil.on.write<int>(keyGems, response.gems!);
        }

        if (response.totalEarnedPoints != null) {
          await PreferenceUtil.on.write<int>(
            keyTotalEarnedPoints,
            response.totalEarnedPoints!,
          );
        }
      }

      Get.log("Response: \'${response.toString()}\'");
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    } finally {
      goToNextPage();
    }
  }

  Future<void> getAppEssentials() async {
    try {
      final response = await RemoteRepository.on().getInAppProducts();

      if (response.isSuccessful && response.items.isNotEmpty) {
        Get.find<LocalService>().storeInAppProducts(response.items);
      }

      Get.log("Response: \'${response.toString()}\'");
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    } finally {
      if (PreferenceUtil.on.read<bool>(keyIsLoggedIn, defaultValue: false)!) {
        getProfileData();
      } else {
        goToNextPage();
      }
    }
  }
}
