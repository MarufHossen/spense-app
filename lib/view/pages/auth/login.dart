import '../../../constants.dart';
import '../../../controller/login_controller.dart';
import '../../../view/pages/auth/registration.dart';
import '../../../controller/binding/registration_binding.dart';
import '../../../view/widgets/central_progress_indicator.dart';
import '../../../view/widgets/custom_filled_button.dart';
import '../../../view/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal.copyWith(
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<LoginController>(
            id: "body",
            init: LoginController(),
            builder: (LoginController viewController) {
              return viewController.isLoading
                  ? const CentralProgressIndicator()
                  : SingleChildScrollView(
                      child: Center(
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
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: const Text(
                                      "Welcome to our app",
                                      style: textStyleHeadline,
                                      textAlign: TextAlign.center,
                                    ).marginOnly(
                                      top: 16.0,
                                      bottom: 8.0,
                                    ),
                                  ),
                                  Text(
                                    "Please sign up/log to use the app",
                                    style: textStyleLarge.copyWith(
                                      color: colorTextSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            CustomTextFormField(
                              formController: controller.emailController,
                              inputType: TextInputType.emailAddress,
                              hint: "Email address",
                              iconPath: "images/ic_email.png",
                            ),
                            CustomTextFormField(
                              formController: controller.passwordController,
                              inputType: TextInputType.visiblePassword,
                              hint: "Password",
                              iconPath: "images/ic_lock.png",
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 8.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              width: double.maxFinite,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.end,
                                  style: textStyleLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorHighlight,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                CustomFilledButton(
                                  title: "Log In",
                                  onTap: () {
                                    controller.login();
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
                                    text: "Don't have an account? ",
                                    style: textStyleRegular,
                                    children: [
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.to(
                                              () => const RegistrationPage(),
                                              binding: RegistrationBinding(),
                                            );
                                          },
                                        text: "Sign Up",
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
                    );
            },
          ),
        ),
      ),
    );
  }
}
