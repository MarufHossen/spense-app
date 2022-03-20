import 'package:spense_app/ui/quiz/view/quiz_controller.dart';
import 'package:get/get.dart';

class ViewQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ViewQuizController());
  }
}
