import 'package:spense_app/data/remote/model/question/question.dart';
import 'package:spense_app/data/remote/response/base_response.dart';

class QuestionResponse extends BaseResponse {
  late List<Question> questions;

  QuestionResponse.fromJson(Map<String, dynamic> json) : super(json) {
    questions = (data as List<dynamic>?)
            ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }
}
