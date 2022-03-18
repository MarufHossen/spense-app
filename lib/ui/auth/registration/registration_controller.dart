import 'package:flutter/material.dart';
import 'package:spense_app/base/exception/app_exception.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/country/country.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/util/helper/keyboard.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/toast.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  late bool isLoading;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  Country? selectedCountry;

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
    } else if (selectedCountry == null) {
      ToastUtil.show('valid_country_required'.tr);
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
        final response = await RemoteRepository.on().register(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
          selectedCountry!,
        );

        if (response.isSuccessful) {
          emailController.clear();
          passwordController.clear();
          nameController.clear();

          Get.back();
        } else {
          if (TextUtil.isNotEmpty(response.message)) {
            ToastUtil.show(response.message);
          } else {
            ToastUtil.show('registration_error'.tr);
          }
        }

        isLoading = false;
        update(["body"]);
      } catch (e) {
        if (e is AppException) {
          ToastUtil.show(e.toString());
        } else {
          ToastUtil.show('registration_error'.tr);
        }

        isLoading = false;
        update(["body"]);
      }
    }
  }
}
