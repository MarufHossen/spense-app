import '../../../constants.dart';
import '../../../controller/registration_controller.dart';
import '../../../view/widgets/central_progress_indicator.dart';
import '../../../view/widgets/custom_filled_button.dart';
import '../../../view/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegistrationPage extends GetView<RegistrationController> {
  const RegistrationPage({Key? key}) : super(key: key);

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
                  ? const CentralProgressIndicator()
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
                                    child: const Icon(
                                      Icons.close,
                                      size: 20.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Welcome to delivery tracker",
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
