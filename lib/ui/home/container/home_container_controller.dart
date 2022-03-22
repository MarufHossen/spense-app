import 'package:flutter/material.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/ui/auth/login/login.dart';
import 'package:spense_app/ui/auth/login/login_binding.dart';
import 'package:spense_app/ui/home/content/home_content.dart';
import 'package:spense_app/ui/leader_board/leader_board.dart';
import 'package:spense_app/ui/profile/view/view_profile.dart';
import 'package:spense_app/ui/shop/view/shop.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart';

import '../../profile/view/view_profile.dart';

class HomeContainerController extends GetxController {
  late Widget body;
  late int selectedBottomBarIndex;

  @override
  void onInit() {
    body = HomeContentPage();
    selectedBottomBarIndex = 0;

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeBottomBarIndex(int index) {
    switch (index) {
      case 0:
        selectedBottomBarIndex = index;
        body = HomeContentPage();
        break;

      case 1:
        selectedBottomBarIndex = index;
        body = LeaderBoardPage();
        break;

      case 2:
        selectedBottomBarIndex = index;
        body = ShopPage();
        break;

      case 3:
        final bool isLoggedIn = PreferenceUtil.on.read<bool>(
          keyIsLoggedIn,
          defaultValue: false,
        )!;

        if (isLoggedIn) {
          selectedBottomBarIndex = index;
          body = ViewProfilePage();
        } else {
          Get.to(
            () => LoginPage(),
            binding: LoginBinding(),
          )?.then((value) {
            if (value != null && value is bool && value) {
              selectedBottomBarIndex = index;
              body = ViewProfilePage();

              update(['bottom_bar', 'body']);
            }
          });
        }
        break;

      default:
        body = Center(
          child: Text("Page 1"),
        );
        break;
    }

    update(['bottom_bar', 'body', 'text_app_bar_title']);
  }
}
