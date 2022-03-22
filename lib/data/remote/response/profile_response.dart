import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/response/base_response.dart';

class ProfileResponse extends BaseResponse {
  late int? id, gems, coins, currentLevel, rank;
  late String? name, country, countryFlag, profileImage, email;
  late int? totalCorrectAnswer, totalWrongAnswer, totalEarnedPoints;

  ProfileResponse.fromJson(Map<String, dynamic> json) : super(json) {
    id = (data as Map<String, dynamic>).containsKey(keyId) ? data[keyId] : null;
    gems = data.containsKey(keyGems) ? data[keyGems] : null;
    coins = data.containsKey(keyCoins) ? data[keyCoins] : null;
    currentLevel =
        data.containsKey(keyCurrentLevel) ? data[keyCurrentLevel] : null;
    rank = data.containsKey(keyRank) ? data[keyRank] : null;

    name = data.containsKey(keyName) ? data[keyName] : null;
    country = data.containsKey(keyCountry) ? data[keyCountry] : null;
    countryFlag =
        data.containsKey(keyCountryFlag) ? data[keyCountryFlag] : null;
    profileImage =
        data.containsKey(keyProfileImage) ? data[keyProfileImage] : null;
    email = data.containsKey(keyEmail) ? data[keyEmail] : null;

    totalCorrectAnswer = data.containsKey(keyTotalCorrectAnswer)
        ? data[keyTotalCorrectAnswer]
        : null;
    totalWrongAnswer = data.containsKey(keyTotalWrongAnswer)
        ? data[keyTotalWrongAnswer]
        : null;
    totalEarnedPoints = data.containsKey(keyTotalEarnedPoints)
        ? data[keyTotalEarnedPoints]
        : null;
  }
}
