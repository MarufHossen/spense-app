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
                                  "Welcome to Spense Trivia",
                                  style: textStyleHeadline,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ).marginOnly(top: 16.0, bottom: 8.0),
                                Text(
                                  "Great, it's a pleasure to have you here. Let's get you setup.",
                                  style: textStyleLarge.copyWith(
                                    color: colorTextSecondary,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              bottom: 16.0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 16.0),
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                          1,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    "images/ic_profile.png",
                                    fit: BoxFit.fitHeight,
                                    height: 40.0,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Profile Image",
                                        style: textStyleHeadline.copyWith(
                                          fontSize: 22.0,
                                        ),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ).marginOnly(bottom: 8.0),
                                      Text(
                                        "Help your friend to recognize you easier in app",
                                        style: textStyleLarge.copyWith(
                                          color: colorTextSecondary,
                                        ),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomTextFormField(
                            formController: viewController.emailController,
                            inputType: TextInputType.emailAddress,
                            hint: "Email address",
                            iconPath: "images/ic_email.png",
                          ),
                          CustomTextFormField(
                            formController: viewController.nameController,
                            inputType: TextInputType.name,
                            hint: "Full Name",
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
                            hint: "Password",
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
                                text:
                                    "By creating account, you agree with our ",
                                style: textStyleRegular.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    text: "Terms & Conditions",
                                    style: textStyleRegular.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorAccent,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style: textStyleRegular.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    text: "Privacy Policy",
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
                                title: "Let's Start",
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
                                  text: "Already have an account? ",
                                  style: textStyleRegular,
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.back();
                                        },
                                      text: "Sign In",
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
