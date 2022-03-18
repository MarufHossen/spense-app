import 'package:flutter/material.dart';
import 'package:spense_app/base/exception/app_exception.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/data/remote/response/base_response.dart';
import 'package:spense_app/util/helper/keyboard.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:spense_app/util/lib/toast.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late bool isLoading;

  @override
  void onInit() {
    isLoading = false;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
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

  Future<void> login() async {
    if (_validateData()) {
      isLoading = true;
      update(["body"]);

      try {
        final response = await RemoteRepository.on().login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (response.isSuccessful && response.userId != null) {
          emailController.clear();
          passwordController.clear();

          PreferenceUtil.on.write<bool>(
            keyIsLoggedIn,
            true,
          );

          PreferenceUtil.on.write<int>(
            keyUserId,
            response.userId!,
          );

          isLoading = false;
          update(["body"]);

          Get.back(result: true);
        } else {
          if (TextUtil.isNotEmpty(response.message)) {
            ToastUtil.show(response.message);
          } else {
            ToastUtil.show('login_error'.tr);
          }

          isLoading = false;
          update(["body"]);
        }
      } catch (e) {
        if (e is AppException) {
          try {
            final BaseResponse errorResponse = BaseResponse(
              e.error!.response!.data,
            );

            ToastUtil.show(
              TextUtil.isNotEmpty(errorResponse.message)
                  ? errorResponse.message
                  : e.toString(),
            );
          } catch (e) {
            ToastUtil.show(e.toString());
          }
        } else {
          ToastUtil.show('login_error'.tr);
        }

        isLoading = false;
        update(["body"]);
      }
    }
  }
}
