import '../../../controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return AnnotatedRegion(
          value: const SystemUiOverlayStyle(
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
              child: Center(
                child: Image.network(
                  "https://www.pngitem.com/pimgs/m/485-4853792_white-motorbike-icon-delivery-png-transparent-png.png",
                  fit: BoxFit.fitHeight,
                  height: 80.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
