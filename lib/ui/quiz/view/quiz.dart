import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:spense_app/base/widget/central_empty_list_placeholder.dart';
import 'package:spense_app/base/widget/central_error_placeholder.dart';
import 'package:spense_app/base/widget/central_progress_indicator.dart';
import 'package:spense_app/base/widget/custom_filled_button.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/question/question.dart';
import 'package:spense_app/data/remote/model/question_choice/question_choice.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/data/remote/response/question_response.dart';
import 'package:spense_app/ui/home/content/home_content_controller.dart';
import 'package:spense_app/ui/quiz/view/quiz_controller.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:spense_app/util/lib/toast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../constants.dart';

class ViewQuizPage extends GetView<ViewQuizController> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: colorPageBackground,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: FutureBuilder<QuestionResponse>(
            future: RemoteRepository.on().getQuestions(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                controller.startQuestionTimer(
                  snapshot.data!,
                  dismissQuiz,
                );

                return Obx(
                  () => controller.isLoading.value
                      ? const CentralProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (PreferenceUtil.on.read<bool>(
                              keyIsLoggedIn,
                              defaultValue: false,
                            )!)
                              buildInformationSection(),
                            if (snapshot.data!.questions.isNotEmpty)
                              buildQuestionCountSection(snapshot.data!),
                            buildAnswerItems(snapshot.data!),
                            buildButtonSection(snapshot.data!),
                          ],
                        ),
                );
              } else if (snapshot.hasError) {
                return CentralErrorPlaceholder(
                  message: "${snapshot.error}",
                );
              }

              return const CentralProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Container buildQuestionCountSection(QuestionResponse data) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      "Question ${(controller.currentQuestionIndex.value + 1).toString().padLeft(2, "0")}",
                      style: textStyleRegular.copyWith(
                        fontSize: 22.0,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    "/",
                    style: textStyleRegular,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    "${data.questions.length.toString().padLeft(2, "0")}",
                    style: textStyleRegular.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTextSecondary,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              Obx(
                () => Text(
                  controller.timeRemainingForQuestion.value != null
                      ? ("00:" +
                          controller.timeRemainingForQuestion.value!
                              .toString()
                              .padLeft(2, "0"))
                      : defaultString,
                  style: textStyleRegular.copyWith(
                    fontSize: 22.0,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ).marginOnly(bottom: 12.0),
          GetBuilder<ViewQuizController>(
            id: "question_count_section",
            init: ViewQuizController(),
            builder: (viewController) {
              return buildQuestionIndicators(data);
            },
          ),
        ],
      ),
    );
  }

  Widget buildQuestionIndicators(QuestionResponse data) {
    List<Widget> children = [];

    final itemWidth =
        (Get.width - (20.0 * 2) - (4.0 * (data.questions.length - 1))) /
            data.questions.length;

    for (int i = 0; i < data.questions.length; i++) {
      bool isPassed = i <= controller.currentQuestionIndex.value;

      children.add(
        Container(
          margin: i < data.questions.length - 1
              ? const EdgeInsets.only(right: 4.0)
              : const EdgeInsets.all(0.0),
          width: itemWidth,
          height: 2.0,
          color: isPassed ? colorAccent : colorDisabled.withOpacity(0.15),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Expanded buildAnswerItems(QuestionResponse data) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        margin: (data.questions.isEmpty)
            ? const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              )
            : const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),
        child: data.questions.isEmpty
            ? CentralEmptyListPlaceholder()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.questions.isNotEmpty)
                      Obx(
                        () => TextUtil.isNotEmpty(data
                                .questions[
                                    controller.currentQuestionIndex.value]
                                .questionImage)
                            ? ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(12.0),
                                ),
                                child: Image.network(
                                  data
                                      .questions[
                                          controller.currentQuestionIndex.value]
                                      .questionImage,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) {
                                    return Container(
                                      height: 170.0,
                                      color: Colors.grey,
                                    );
                                  },
                                  fit: BoxFit.contain,
                                  height: 170.0,
                                  width: double.maxFinite,
                                ),
                              ).marginOnly(bottom: 16.0)
                            : SizedBox.shrink(),
                      ),
                    GetBuilder<ViewQuizController>(
                      id: "hint",
                      builder: (_) {
                        if (data.questions.isNotEmpty &&
                            !data
                                .questions[
                                    controller.currentQuestionIndex.value]
                                .isHintApplied) {
                          return GestureDetector(
                            onTap: () {
                              int index = controller.currentQuestionIndex.value;
                              showHintPopUp(
                                data.questions[index],
                                data,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: colorTextWarning.withOpacity(0.17),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15.0),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outlined,
                                    color: colorTextWarning,
                                    size: 16.0,
                                  ).marginOnly(right: 8.0),
                                  Text(
                                    "Hint",
                                    style: textStyleRegular.copyWith(
                                      color: colorTextWarning,
                                    ),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                    if (data.questions.isNotEmpty)
                      Obx(
                        () => Text(
                          "${data.questions[controller.currentQuestionIndex.value].title}",
                          style: textStyleFocused.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ).marginOnly(bottom: 12.0),
                      ),
                    GetBuilder<ViewQuizController>(
                      id: "list_view_answer_items",
                      init: ViewQuizController(),
                      builder: (viewController) {
                        if (data.questions.isEmpty) {
                          return SizedBox.shrink();
                        } else {
                          final choices = data
                              .questions[controller.currentQuestionIndex.value]
                              .questionChoices;
                          return ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return buildItem(
                                data,
                                choices[index],
                                index,
                              );
                            },
                            separatorBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return SizedBox(height: 12.0);
                            },
                            itemCount: choices.length,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildButtonSection(QuestionResponse data) {
    return CustomFilledButton(
      title: "Quit Quiz",
      onTap: () {
        dismissQuiz(data);
      },
      backgroundColor: colorTextWarning,
      textColor: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
    ).marginSymmetric(
      horizontal: 8.0,
      vertical: 16.0,
    );
  }

  Future<void> tapOnNext(QuestionResponse data) async {
    final questionIndex = controller.currentQuestionIndex.value;

    if (!controller.givenAnswers.containsKey(questionIndex)) {
      ToastUtil.show("Please answer the current question");
      return;
    }

    final givenAnswerIndex = controller.givenAnswers[questionIndex]!;
    final questions = data.questions;
    final questionChoices = questions[questionIndex].questionChoices;
    final chosenOption = questionChoices[givenAnswerIndex];

    if (questionIndex < questions.length - 1 && chosenOption.isRightOption) {
      controller.startRightWrongTimer();
      showRightWrongPopUp(true).then(
        (_) {
          controller.changeQuestionIndex(
            questionIndex + 1,
            questions[questionIndex],
          );
          controller.startQuestionTimer(
            data,
            dismissQuiz,
          );
        },
      );
    } else {
      controller.startRightWrongTimer();
      showRightWrongPopUp(false).then(
        (_) {
          dismissQuiz(data);
        },
      );
    }
  }

  Future<void> dismissQuiz(QuestionResponse data) async {
    final shouldShowResult = await controller.calculateResult(
      data.questions,
      isTimeExceeded: true,
    );

    if (shouldShowResult) {
      showResultPopUp(data);
    } else {
      controller.goBack();
    }
  }

  Widget buildInformationSection() {
    return GetBuilder<ViewQuizController>(
      id: "user_information",
      builder: (_) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/ic_level.png",
                      fit: BoxFit.fitHeight,
                      height: 28.0,
                    ).marginOnly(right: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Level",
                          style: textStyleRegular.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          controller.currentLevel!.toString(),
                          style: textStyleRegular,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                decoration: const BoxDecoration(
                  color: colorGem,
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(18.0),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "images/ic_gem.png",
                      fit: BoxFit.fitHeight,
                      height: 16.0,
                    ).marginOnly(right: 8.0),
                    Text(
                      "${PreferenceUtil.on.read<int>(
                        keyGems,
                        defaultValue: 0,
                      )}",
                      style: textStyleRegular.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: colorCoin,
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(18.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "images/ic_coin.png",
                      fit: BoxFit.fitHeight,
                      height: 16.0,
                    ).marginOnly(right: 8.0),
                    Text(
                      "${PreferenceUtil.on.read<int>(
                        keyCoins,
                        defaultValue: 0,
                      )}",
                      style: textStyleRegular.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildItem(
    QuestionResponse data,
    QuestionChoice item,
    int index,
  ) {
    return GetBuilder<ViewQuizController>(
      init: ViewQuizController(),
      builder: (viewController) {
        bool isSelected = (viewController.selectedIndex != null &&
            viewController.selectedIndex == index);

        return GestureDetector(
          onTap: item.isActive
              ? () {
                  viewController.selectItem(index);
                  tapOnNext(data);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              color: item.isActive
                  ? (isSelected
                      ? (item.isRightOption
                          ? colorAccent.withOpacity(0.15)
                          : colorTextWarning.withOpacity(0.17))
                      : colorPageBackground)
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            child: Text(
              "${item.optionName}",
              style: textStyleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: item.isActive
                    ? (isSelected
                        ? (item.isRightOption ? colorAccent : colorTextWarning)
                        : colorTextRegular)
                    : Colors.transparent,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              //maxLines: 3,
            ),
          ),
        );
      },
    );
  }

  void showHintPopUp(
    Question currentQuestion,
    QuestionResponse data,
  ) {
    Get.defaultDialog(
      title: "",
      content: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 16.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "images/ic_gem.png",
                            height: 32.0,
                            fit: BoxFit.fitHeight,
                          ),
                          SizedBox(width: 16.0),
                          Text(
                            "${PreferenceUtil.on.read<int>(
                                  keyGems,
                                  defaultValue: 0,
                                )}" +
                                "\nGems",
                            style: textStyleRegular.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "images/ic_coin.png",
                            height: 32.0,
                            fit: BoxFit.fitHeight,
                          ),
                          SizedBox(width: 16.0),
                          Text(
                            "${PreferenceUtil.on.read<int>(
                                  keyCoins,
                                  defaultValue: 0,
                                )}" +
                                "\nCoins",
                            style: textStyleRegular.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ).marginOnly(
                    bottom: 32.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  Text(
                    "Wait",
                    style: textStyleExtraExtraLarge,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Skip 2 choices so you can guess easily!",
                    style: textStyleExtraLarge.copyWith(
                      color: colorTextSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ).marginOnly(
                    bottom: 0.0,
                    top: 12.0,
                  ),
                ],
              ),
            ),
            CustomFilledButton(
              title: "Watch a video",
              onTap: () {
                controller.showAd(data, dismissQuiz, currentQuestion);
              },
            ),
            CustomFilledButton(
              title: "Use Coins",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Use Coins",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "Product Sans",
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  Image.asset(
                    "images/ic_coin.png",
                    fit: BoxFit.fitHeight,
                    height: 20.0,
                  ).marginOnly(
                    left: 24.0,
                    right: 12.0,
                  ),
                  Text(
                    "${controller.coinAmountForHint}",
                    style: textStyleFocused.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              backgroundColor: colorCoin,
              onTap: () async {
                Get.back();
                controller.decrementCoinByApplyingHint(
                  controller.coinAmountForHint,
                  currentQuestion,
                );
              },
            ),
            Text(
              "You can skip the question as well!",
              style: textStyleExtraLarge.copyWith(
                color: colorTextSecondary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ).marginOnly(
              top: 32.0,
              bottom: 8.0,
            ),
            CustomFilledButton(
              title: "Use Gems",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Use Gems",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "Product Sans",
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  Image.asset(
                    "images/ic_gem.png",
                    fit: BoxFit.fitHeight,
                    height: 20.0,
                  ).marginOnly(
                    left: 24.0,
                    right: 12.0,
                  ),
                  Text(
                    "${controller.gemAmountForHint}",
                    style: textStyleFocused.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              backgroundColor: colorGem,
              onTap: () async {
                Get.back();
                final shouldSkip =
                    await controller.decrementGemBySkippingQuestion(
                  controller.gemAmountForHint,
                  currentQuestion,
                );

                if (shouldSkip) {
                  tapOnNext(data);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showRightWrongPopUp(bool isRight) async {
    await Get.defaultDialog(
      barrierDismissible: false,
      title: "",
      onWillPop: () async {
        return false;
      },
      content: Container(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'animations/${isRight ? 'correct.json' : 'wrong.json'}',
              width: 120.0,
              height: 120.0,
              repeat: false,
            ).marginOnly(bottom: 12.0),
            Text(
              isRight ? "Correct" : "Next time, Do better",
              style: textStyleExtraExtraLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void showResultPopUp(QuestionResponse data) {
    final pointPercentage =
        controller.currentPoint! / controller.nextLevelStartingBoundary!;

    Get.defaultDialog(
      barrierDismissible: false,
      title: "",
      onWillPop: () async {
        return false;
      },
      content: Expanded(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Good Job!".toUpperCase(),
                      style: textStyleExtraExtraLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Let's try again!",
                      style: textStyleExtraLarge.copyWith(
                        color: colorTextSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ).marginOnly(
                      top: 12.0,
                    ),
                    Center(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          CircularPercentIndicator(
                            radius: 175.0,
                            animation: false,
                            lineWidth: 8.0,
                            percent: 1.0,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Points Earned",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0,
                                    color: colorDisabled,
                                  ),
                                ).marginOnly(bottom: 4.0),
                                Text(
                                  "${controller.currentPoint! - controller.initialPoint!}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                    color: colorDisabled.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: colorAccent,
                            progressColor: colorAccent,
                          ).marginOnly(top: 18.0),
                          Image.asset(
                            "images/ic_done_circle.png",
                            fit: BoxFit.fitHeight,
                            height: 48.0,
                          ),
                        ],
                      ),
                    ).marginSymmetric(vertical: 20.0),
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        LinearPercentIndicator(
                          animation: false,
                          lineHeight: 32.0,
                          padding:
                              const EdgeInsets.only(left: 22.0, right: 16.0),
                          percent:
                              pointPercentage > 1.0 ? 1.0 : pointPercentage,
                          center: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.currentPoint!.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                " / ${controller.nextLevelStartingBoundary!.toString()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: colorAccent,
                          progressColor: colorHighlight,
                        ),
                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                colorGem,
                                BlendMode.srcIn,
                              ),
                              image: AssetImage("images/ic_level_tag.png"),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.currentLevel!.toString(),
                              style: textStyleLarge.copyWith(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ).marginOnly(bottom: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: buildStatisticsItem(
                            "Correct",
                            "${controller.rightAnswers.toString().padLeft(2, "0")}",
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: buildStatisticsItem(
                            "Wrong",
                            "${controller.wrongAnswers.toString().padLeft(2, "0")}",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomFilledButton(
                title: "Return to Home",
                onTap: () async {
                  await Get.find<HomeContentController>().getProfileData();
                  controller.goBack(
                    closeOverlays: true,
                    result: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildStatisticsItem(String title, String subtitle) {
    return Column(
      children: [
        Text(
          subtitle,
          style: textStyleSectionItemBody,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ).marginOnly(bottom: 4.0),
        Text(
          title,
          style: textStyleSectionItemTitle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
