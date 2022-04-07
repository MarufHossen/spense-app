import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                child: Center(
                    child: Text("Spense",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: colorPageBackground,
                        )).marginOnly(
                  top: 12.0,
                  bottom: 4.0,
                ))),
          ),
        );
      },
    );
  }
}
