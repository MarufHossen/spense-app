import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:spense_app/base/exception/app_exception.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/local/local_service.dart';
import 'package:spense_app/data/remote/model/question/question.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/data/remote/response/question_response.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:spense_app/util/lib/toast.dart';
import 'package:get/get.dart';

typedef DismissQuizCallback = Future<void> Function(QuestionResponse data);

const int timeForEachQuestionInSeconds = 20, timeAfterEachAnswer = 2;

class ViewQuizController extends GetxController {
  late RxBool isLoading;
  late RxInt currentQuestionIndex;
  late int rightAnswers, wrongAnswers, pointToBeAdded;
  late int gemAmountForHint, coinAmountForHint;
  int? selectedIndex;
  late HashMap<int, int> givenAnswers;
  late List<int> seenQuestionIds;
  late HashMap<int, int> questionWisePointMap;
  Timer? questionTimer, rightWrongTimer;
  late RxnInt timeRemainingForQuestion, timeRemainingAfterAnswer;
  int? initialPoint, currentPoint, currentLevel, nextLevel;
  int? nextLevelStartingBoundary;

  @override
  void onInit() {
    seenQuestionIds = [];
    isLoading = false.obs;
    currentQuestionIndex = 0.obs;
    rightAnswers = 0;
    wrongAnswers = 0;
    pointToBeAdded = 0;
    gemAmountForHint = 10;
    coinAmountForHint = 10;
    givenAnswers = HashMap<int, int>();

    questionWisePointMap = HashMap<int, int>();
    questionWisePointMap[0] = 100;
    questionWisePointMap[1] = 200;
    questionWisePointMap[2] = 300;
    questionWisePointMap[3] = 500;
    questionWisePointMap[4] = 750;
    questionWisePointMap[5] = 1000;
    questionWisePointMap[6] = 1500;
    questionWisePointMap[7] = 2000;
    questionWisePointMap[8] = 2500;
    questionWisePointMap[9] = 3000;
    questionWisePointMap[10] = 4000;
    questionWisePointMap[11] = 5000;
    questionWisePointMap[12] = 6000;
    questionWisePointMap[13] = 7000;
    questionWisePointMap[14] = 8000;
    questionWisePointMap[15] = 9000;
    questionWisePointMap[16] = 10000;
    questionWisePointMap[17] = 11000;
    questionWisePointMap[18] = 12000;
    questionWisePointMap[19] = 15000;

    timeRemainingForQuestion = RxnInt();
    timeRemainingAfterAnswer = RxnInt();

    initialPoint = PreferenceUtil.on.read<int>(
      keyTotalEarnedPoints,
      defaultValue: 1,
    );
    calculateStatistics();

    super.onInit();

    loadRewardedAd();
  }

  @override
  void onClose() {
    if (questionTimer != null) {
      questionTimer!.cancel();
    }

    if (rightWrongTimer != null) {
      rightWrongTimer!.cancel();
    }

    super.onClose();
  }

  void calculateStatistics() {
    final service = Get.find<LocalService>();

    currentPoint = PreferenceUtil.on.read<int>(
      keyTotalEarnedPoints,
      defaultValue: 1,
    );
    currentLevel = service.getCurrentLevel(currentPoint!);
    nextLevel = currentLevel! + 1;
    nextLevelStartingBoundary = service.getLevelStartingPoint(nextLevel!);
  }

  void startRightWrongTimer() {
    if (questionTimer != null) {
      questionTimer!.cancel();
    }

    if (rightWrongTimer != null) {
      rightWrongTimer!.cancel();
    }

    const oneSecond = const Duration(seconds: 1);
    timeRemainingAfterAnswer.value = timeAfterEachAnswer;

    rightWrongTimer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        if (timeRemainingAfterAnswer.value != null) {
          if (timeRemainingAfterAnswer.value == 0) {
            timer.cancel();
            Get.back();
          } else {
            timeRemainingAfterAnswer.value =
                timeRemainingAfterAnswer.value! - 1;
          }
        }
      },
    );
  }

  void startQuestionTimer(
    QuestionResponse data,
    DismissQuizCallback callback,
  ) {
    if (questionTimer != null) {
      questionTimer!.cancel();
    }

    const oneSecond = const Duration(seconds: 1);
    timeRemainingForQuestion.value = timeForEachQuestionInSeconds;

    questionTimer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        if (timeRemainingForQuestion.value != null) {
          if (timeRemainingForQuestion.value == 0) {
            timer.cancel();
            callback(data);
          } else {
            timeRemainingForQuestion.value =
                timeRemainingForQuestion.value! - 1;
          }
        }
      },
    );
  }

  void selectItem(int index) {
    selectedIndex = index;
    givenAnswers[currentQuestionIndex.value] = selectedIndex!;
    update(["list_view_answer_items"]);
  }

  void changeQuestionIndex(int nextQuestionIndex, Question question) {
    if (selectedIndex != null) {
      givenAnswers[currentQuestionIndex.value] = selectedIndex!;
    }

    currentQuestionIndex.value = nextQuestionIndex;

    if (givenAnswers.containsKey(currentQuestionIndex.value)) {
      selectedIndex = givenAnswers[currentQuestionIndex.value];
    } else {
      selectedIndex = null;
    }

    update([
      "body",
      "question_count_section",
      "list_view_answer_items",
      "hint",
    ]);
  }

  void goBack({
    bool result = false,
    bool closeOverlays = false,
  }) {
    if (questionTimer != null && questionTimer!.isActive) {
      questionTimer?.cancel();
    }

    if (rightWrongTimer != null && rightWrongTimer!.isActive) {
      rightWrongTimer?.cancel();
    }

    Get.back(
      result: result,
      closeOverlays: closeOverlays,
    );
  }

  /*
  * Returns a boolean which indicates if the result popup should be shown
  * */
  Future<bool> calculateResult(
    List<Question> questionList, {
    bool isTimeExceeded = false,
  }) async {
    if (givenAnswers.isEmpty) {
      return false;
    } else {
      if (questionTimer != null && questionTimer!.isActive) {
        questionTimer?.cancel();
      }

      seenQuestionIds.clear();

      for (int i = 0; i < questionList.length; i++) {
        final question = questionList[i];

        if (givenAnswers.containsKey(i)) {
          seenQuestionIds.add(question.id);
          final givenAnswer = givenAnswers[i]!;

          if (question.questionChoices[givenAnswer].isRightOption) {
            rightAnswers++;
          } else {
            wrongAnswers++;
          }
        }
      }

      if (isTimeExceeded &&
          !givenAnswers.containsKey(currentQuestionIndex.value)) {
        wrongAnswers++;
        givenAnswers[currentQuestionIndex.value] = -1;
      }

      for (int i = 0; i < rightAnswers; i++) {
        pointToBeAdded += questionWisePointMap[i]!;
      }

      final flag = await updateScore(
        rightAnswers,
        wrongAnswers,
        pointToBeAdded,
        seenQuestionIds,
      );

      currentQuestionIndex.value = defaultInt;

      return flag;
    }
  }

  Future<void> applyHint(Question question) async {
    int disablingCount = 0;
    HashMap<int, bool> foundIndexMap = HashMap<int, bool>();

    while (disablingCount < 2) {
      int randomIndex = Random().nextInt(question.questionChoices.length - 1);

      if (!question.questionChoices[randomIndex].isRightOption &&
          !(foundIndexMap.containsKey(randomIndex) &&
              foundIndexMap[randomIndex]!)) {
        foundIndexMap[randomIndex] = true;
        question.questionChoices[randomIndex].isActive = false;
        disablingCount++;
      }
    }

    question.isHintApplied = true;

    update(["hint", "list_view_answer_items", "user_information"]);
  }

  /*
  * Returns a boolean indicating that the score has been updated or not
  * */
  Future<bool> updateScore(
    int rightAnswers,
    int wrongAnswers,
    int pointToBeAdded,
    List<int> seenQuestionIds,
  ) async {
    try {
      final response = await RemoteRepository.on().updateScore(
        rightAnswers,
        wrongAnswers,
        pointToBeAdded,
        seenQuestionIds,
      );

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

          calculateStatistics();
        }

        return true;
      } else {
        if (TextUtil.isNotEmpty(response.message)) {
          ToastUtil.show(response.message);
        } else {
          ToastUtil.show('quiz_error_point_submission'.tr);
        }

        return false;
      }
    } catch (e) {
      if (e is AppException) {
        ToastUtil.show(e.toString());
      } else {
        ToastUtil.show('quiz_error_point_submission'.tr);
      }

      return false;
    }
  }

  /*
  * Returns a flag indicating, hint should be applied or not
  * */
  Future<bool> decrementCoinByApplyingHint(
    int amount,
    Question question,
  ) async {
    try {
      final currentCoins = PreferenceUtil.on.read<int>(
        keyCoins,
        defaultValue: -1,
      )!;

      if (currentCoins <= 0 || currentCoins < amount) {
        ToastUtil.show("You do not have enough coin");
        return false;
      } else {
        final response = await RemoteRepository.on().decrementCoin(amount);

        if (response.isSuccessful) {
          if (response.coins != null) {
            await PreferenceUtil.on.write<int>(
              keyCoins,
              response.coins!,
            );
          }

          if (response.gems != null) {
            await PreferenceUtil.on.write<int>(
              keyGems,
              response.gems!,
            );
          }

          if (response.totalEarnedPoints != null) {
            await PreferenceUtil.on.write<int>(
              keyTotalEarnedPoints,
              response.totalEarnedPoints!,
            );
          }

          await applyHint(question);
          return true;
        } else {
          if (TextUtil.isNotEmpty(response.message)) {
            ToastUtil.show(response.message);
          } else {
            ToastUtil.show('quiz_error_decrement_coin'.tr);
          }

          return false;
        }
      }
    } catch (e) {
      if (e is AppException) {
        ToastUtil.show(e.toString());
      } else {
        ToastUtil.show('quiz_error_decrement_coin'.tr);
      }

      return false;
    }
  }

  /*
  * Returns a flag indicating, the question should be skipped or not
  * */
  Future<bool> decrementGemBySkippingQuestion(
    int amount,
    Question question,
  ) async {
    try {
      final currentGems = PreferenceUtil.on.read<int>(
        keyGems,
        defaultValue: -1,
      )!;

      if (currentGems <= 0 || currentGems < amount) {
        ToastUtil.show("You do not have enough gem");
        return false;
      } else {
        final response = await RemoteRepository.on().decrementGem(amount);

        if (response.isSuccessful) {
          if (response.coins != null) {
            await PreferenceUtil.on.write<int>(
              keyCoins,
              response.coins!,
            );
          }

          if (response.gems != null) {
            await PreferenceUtil.on.write<int>(
              keyGems,
              response.gems!,
            );
          }

          if (response.totalEarnedPoints != null) {
            await PreferenceUtil.on.write<int>(
              keyTotalEarnedPoints,
              response.totalEarnedPoints!,
            );
          }

          for (int i = 0; i < question.questionChoices.length; i++) {
            final choice = question.questionChoices[i];

            if (choice.isRightOption) {
              givenAnswers[currentQuestionIndex.value] = i;
              break;
            }
          }

          update(["user_information"]);
          return true;
        } else {
          if (TextUtil.isNotEmpty(response.message)) {
            ToastUtil.show(response.message);
          } else {
            ToastUtil.show('quiz_error_decrement_gem'.tr);
          }

          return false;
        }
      }
    } catch (e) {
      if (e is AppException) {
        ToastUtil.show(e.toString());
      } else {
        ToastUtil.show('quiz_error_decrement_gem'.tr);
      }

      return false;
    }
  }

  Future<void> loadRewardedAd() async {}

  Future<void> showAd(
    QuestionResponse data,
    DismissQuizCallback callback,
    Question question,
  ) async {}
}
