import 'package:spense_app/ui/home/container/home_container_controller.dart';
import 'package:spense_app/ui/leader_board/leader_board_controller.dart';
import 'package:spense_app/ui/profile/view/view_profile_controller.dart';
import 'package:spense_app/ui/shop/view/shop_controller.dart';
import 'package:get/get.dart';

class HomeContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeContainerController());
    Get.lazyPut(() => ViewProfileController());
    Get.lazyPut(() => LeaderBoardController());
    Get.lazyPut(() => ShopPageController());
  }
}
