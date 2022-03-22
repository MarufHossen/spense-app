import 'package:spense_app/data/remote/model/user/user.dart';
import 'package:spense_app/data/remote/response/base_response.dart';

class LeaderBoardDataResponse extends BaseResponse {
  late List<User> items;

  LeaderBoardDataResponse.fromJson(Map<String, dynamic> json) : super(json) {
    items = (data as List<dynamic>?)
            ?.map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }
}
