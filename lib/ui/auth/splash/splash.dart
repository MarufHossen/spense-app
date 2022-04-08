import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spense_app/base/widget/custom_filled_button.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/ui/auth/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/ic_splash_background.png"),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                        child: Text("Spense",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: colorPageBackground,
                            )).marginOnly(
                      top: 12.0,
                      bottom: 4.0,
                    )),
                    FutureBuilder<String?>(
                      future: controller.getLanguage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == "unset") {
                          return CustomFilledButton(
                            title: "English",
                            textColor: colorTextRegular,
                            backgroundColor: colorInputFieldBackground,
                            onTap: () {
                              controller.setLanguage("en");
                            },
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 40.0,
                              bottom: 16.0,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    FutureBuilder<String?>(
                      future: controller.getLanguage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == "unset") {
                          return CustomFilledButton(
                            title: "Bengali",
                            textColor: colorTextRegular,
                            backgroundColor: colorInputFieldBackground,
                            onTap: () {
                              controller.setLanguage("bn");
                            },
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 40.0,
                              bottom: 16.0,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
