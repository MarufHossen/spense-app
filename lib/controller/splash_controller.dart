import 'dart:async';
import '../constants.dart';
import '../util/lib/preference.dart';
import '../view/pages/auth/login.dart';
import '../view/pages/home/home.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void goToNextPage() {
    Get.offAll(
      () => const Home(),
      // binding: HomeContainerBinding(),
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
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    getAppEssentials();
  }

  Future<void> getAppEssentials() async {
    try {
      bool? isLoggedIn = PreferenceUtil.on.read<bool>(keyIsLoggedIn);
      if (isLoggedIn != null && isLoggedIn) {
        Get.to(const Home());
      } else {
        Get.to(const LoginPage());
      }
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    }
  }
}
