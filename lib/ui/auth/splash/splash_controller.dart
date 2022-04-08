import 'dart:async';
import 'dart:ui';

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
    checkLanguage();
    // getAppEssentials();
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

  Future<void> setLanguage(String lang) async {
    var locale = Locale(lang);
    Get.updateLocale(locale);
    try {
      await PreferenceUtil.on.write<String>(keyLanguage, lang);
      Get.log("Set Languge: \'${lang.toString()}\'");
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    } finally {
      getAppEssentials();
    }
  }

  Future<void> checkLanguage() async {
    try {
      // await PreferenceUtil.on.write<String>(keyLanguage, "unset");
      String? lang = await PreferenceUtil.on
          .read<String>(keyLanguage, defaultValue: "unset");

      Get.log("Check Languge: \'${lang.toString()}\'");
      if (lang != "unset") {
        var locale = Locale(lang!);
        Get.updateLocale(locale);
        getAppEssentials();
      }
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    }
  }

  Future<String?> getLanguage() async {
    try {
      String? lang = await PreferenceUtil.on
          .read<String>(keyLanguage, defaultValue: "unset");

      Get.log("Get Languge: \'${lang.toString()}\'");
      if (lang != "unset") {
        return lang;
      }
      return "unset";
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    }
  }
}
