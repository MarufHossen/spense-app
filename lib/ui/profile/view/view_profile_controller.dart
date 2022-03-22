import 'package:spense_app/constants.dart';
import 'package:spense_app/data/local/local_service.dart';
import 'package:spense_app/data/remote/response/profile_response.dart';
import 'package:spense_app/ui/auth/login/login.dart';
import 'package:spense_app/ui/auth/login/login_binding.dart';
import 'package:spense_app/ui/home/container/home_container_controller.dart';
import 'package:spense_app/ui/home/content/home_content.dart';
import 'package:spense_app/ui/profile/view/view_profile.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart';

class ViewProfileController extends GetxController {
  int? currentPoint, currentLevel, nextLevel;
  int? nextLevelStartingBoundary;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void calculateStatistics(ProfileResponse data) {
    final service = Get.find<LocalService>();

    currentPoint = data.totalEarnedPoints!;
    currentLevel = service.getCurrentLevel(currentPoint!);
    nextLevel = currentLevel! + 1;
    nextLevelStartingBoundary = service.getLevelStartingPoint(nextLevel!);
  }

  void logOut() {
    PreferenceUtil.on.write<bool>(
      keyIsLoggedIn,
      false,
    );

    PreferenceUtil.on.delete(keyUserId);

    Get.to(
      () => LoginPage(),
      binding: LoginBinding(),
    )?.then((value) {
      final containerController = Get.find<HomeContainerController>();

      if (value != null && value is bool && value) {
        containerController.selectedBottomBarIndex = 3;
        containerController.body = ViewProfilePage();
      } else {
        containerController.selectedBottomBarIndex = 0;
        containerController.body = HomeContentPage();
      }

      containerController.update(['bottom_bar', 'body']);
    });
  }
}
