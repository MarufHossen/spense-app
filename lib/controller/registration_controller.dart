import '../api/auth_api.dart';
import '../constants.dart';
import '../model/auth.dart';
import '../util/helper/keyboard.dart';
import '../util/helper/text.dart';
import '../util/lib/preference.dart';
import '../util/lib/toast.dart';
import '../view/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  late bool isLoading;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    isLoading = false;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  bool _validateData() {
    if (Get.context != null) {
      KeyboardUtil.hideKeyboard(Get.context!);
    }

    if (!TextUtil.isNotEmpty(emailController.text) ||
        !TextUtil.isNotEmpty(passwordController.text)) {
      ToastUtil.show('fill_up_all_fields'.tr);
      return false;
    } else if (!(RegExp(regularExpressionEmail).hasMatch(
      emailController.text.trim(),
    ))) {
      ToastUtil.show('valid_email_required'.tr);
      return false;
    } else if (passwordController.text.trim().length < minimumPasswordLength) {
      ToastUtil.show('minimum_password_length_required'.tr);
      return false;
    } else {
      return true;
    }
  }

  Future<void> register() async {
    if (_validateData()) {
      isLoading = true;
      update(["body"]);

      try {
        Auth auth =
            Auth(emailController.text.trim(), passwordController.text.trim());
        auth.name = nameController.text.trim();
        Auth authResponse = await AuthApi.register(auth);

        if (authResponse.success && authResponse.id != null) {
          emailController.clear();
          passwordController.clear();

          PreferenceUtil.on.write<bool>(
            keyIsLoggedIn,
            true,
          );

          PreferenceUtil.on.write<int>(
            keyUserId,
            authResponse.id!,
          );

          isLoading = false;
          update(["body"]);

          Get.offAll(
            () => const Home(),
            // binding: HomeContainerBinding(),
          );
        } else {
          if (TextUtil.isNotEmpty(authResponse.name)) {
            ToastUtil.show(authResponse.name!);
          } else {
            ToastUtil.show('registration_error'.tr);
          }

          isLoading = false;
          update(["body"]);
        }
      } catch (e) {
        ToastUtil.show('registration_error'.tr);
        ToastUtil.show(e.toString());

        isLoading = false;
        update(["body"]);
      }

      isLoading = false;
      update(["body"]);
    }
  }
}
