import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spense_app/base/widget/central_progress_indicator.dart';
import 'package:spense_app/base/widget/custom_drop_down_button.dart';
import 'package:spense_app/base/widget/custom_filled_button.dart';
import 'package:spense_app/base/widget/custom_text_form_field.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/country/country.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/data/remote/response/country_data_response.dart';
import 'package:spense_app/ui/auth/registration/registration_controller.dart';
import 'package:get/get.dart';

class RegistrationPage extends GetView<RegistrationController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      id: "body",
      init: RegistrationController(),
      builder: (viewController) {
        return AnnotatedRegion(
          value: systemUiOverlayStyleGlobal.copyWith(
            systemNavigationBarColor: Colors.white,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: viewController.isLoading
                  ? CentralProgressIndicator()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              bottom: 28.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorCloseButtonBackground,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 20.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  "welcome_to_trivia".tr,
                                  style: textStyleHeadline,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ).marginOnly(top: 16.0, bottom: 8.0),
                              ],
                            ),
                          ),
                          CustomTextFormField(
                            formController: viewController.emailController,
                            inputType: TextInputType.emailAddress,
                            hint: "email_address".tr,
                            iconPath: "images/ic_email.png",
                          ),
                          CustomTextFormField(
                            formController: viewController.nameController,
                            inputType: TextInputType.name,
                            hint: "nickname".tr,
                            iconPath: "images/ic_user.png",
                          ),
                          FutureBuilder<CountryDataResponse>(
                            future: RemoteRepository.on().getCountries(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return CustomDropDownButton(
                                  items: snapshot.data!.items,
                                  prefixIconPath: "images/ic_country.png",
                                  hint: "Country",
                                  onChanged: (Country? value) {
                                    controller.selectedCountry = value;
                                  },
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          CustomTextFormField(
                            formController: viewController.passwordController,
                            inputType: TextInputType.visiblePassword,
                            hint: "password".tr,
                            iconPath: "images/ic_lock.png",
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 24.0,
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "creating_account_agreement".tr + " ",
                                style: textStyleRegular.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    text: "terms_and_conditions".tr,
                                    style: textStyleRegular.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorAccent,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " " + "and".tr + " ",
                                    style: textStyleRegular.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    text: "privacy_policy".tr,
                                    style: textStyleRegular.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              CustomFilledButton(
                                title: "sign_up".tr,
                                onTap: () {
                                  controller.register();
                                },
                                margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 40.0,
                                  bottom: 16.0,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "already_have_account".tr + " ",
                                  style: textStyleRegular,
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.back();
                                        },
                                      text: "sign_in".tr,
                                      style: textStyleRegular.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
