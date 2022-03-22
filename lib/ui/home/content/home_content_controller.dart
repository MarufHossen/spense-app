import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/data/remote/response/leader_board_data_response.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart';

class HomeContentController extends GetxController {
  late bool isLoading;
  late Future<LeaderBoardDataResponse> loadTopThreeScorer;

  @override
  void onInit() {
    isLoading = false;
    loadTopThreeScorer = RemoteRepository.on().getLeaderBoardData();

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void refreshPage() {
    loadTopThreeScorer = RemoteRepository.on().getLeaderBoardData();
    update(["user_information", "leader_board"]);
  }

  Future<void> getProfileData() async {
    try {
      final response = await RemoteRepository.on().getProfileData();

      if (response.isSuccessful) {
        if (response.coins != null) {
          await PreferenceUtil.on.write<int>(keyCoins, response.coins!);
        }

        if (response.gems != null) {
          await PreferenceUtil.on.write<int>(keyGems, response.gems!);
        }

        if (response.totalEarnedPoints != null) {
          await PreferenceUtil.on.write<int>(
            keyTotalEarnedPoints,
            response.totalEarnedPoints!,
          );
        }
      }

      Get.log("Response: \'${response.toString()}\'");
    } catch (e) {
      Get.log("Error: ${e.toString()}");
    }
  }
}
