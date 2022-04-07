import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spense_app/base/widget/central_error_placeholder.dart';
import 'package:spense_app/base/widget/central_progress_indicator.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/user/user.dart';
import 'package:spense_app/data/remote/response/leader_board_data_response.dart';
import 'package:spense_app/ui/home/content/home_content_controller.dart';
import 'package:spense_app/ui/quiz/view/quiz.dart';
import 'package:spense_app/ui/quiz/view/quiz_binding.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:spense_app/util/lib/toast.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class HomeContentPage extends GetView<HomeContentController> {
  final itemSizeSingle = 35.0;
  final itemSizeDouble = 65.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal.copyWith(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: colorPageBackground,
        extendBodyBehindAppBar: true,
        body: GetBuilder<HomeContentController>(
          id: "body",
          init: HomeContentController(),
          builder: (viewController) {
            if (viewController.isLoading) {
              return CentralProgressIndicator();
            } else {
              return SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(),
                      buildBanner(),
                      buildIntroductionSection(),
                      buildListHeader(),
                      buildList(),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Center(
        child: Text("Spense",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: colorTextRegular,
            )).marginOnly(
      top: 12.0,
      bottom: 4.0,
    ));
  }

  Widget buildBanner() {
    return GestureDetector(
      onTap: () {
        if (PreferenceUtil.on.read<bool>(
          keyIsLoggedIn,
          defaultValue: false,
        )!) {
          Get.to(
            () => ViewQuizPage(),
            binding: ViewQuizBinding(),
          )?.then(
            (value) {
              controller.refreshPage();
            },
          );
        } else {
          ToastUtil.show("Log in to play the quiz");
        }
      },
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.all(32.0),
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/ic_background_home_banner.png"),
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                const Radius.circular(12.0),
              ),
            ),
            child: Text(
              "play_quiz".tr.toUpperCase(),
              style: textStyleLarge.copyWith(
                color: colorAccent,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIntroductionSection() {
    return GetBuilder<HomeContentController>(
      id: "user_information",
      builder: (_) {
        return Container(
          margin: const EdgeInsets.only(
            left: 22.0,
            right: 22.0,
            bottom: 40.0,
            top: 16.0,
          ),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "are_you_quiz_expert_text".tr,
                style: textStyleExtraLarge,
                textAlign: TextAlign.center,
              ).marginOnly(bottom: 6.0),
              Text(
                "20_question_answer".tr,
                style: textStyleLarge.copyWith(
                  color: colorTextRegular,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildListHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "leader_board".tr,
          style: textStyleExtraLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ).marginSymmetric(horizontal: 23.0),
        Row(
          children: [
            Expanded(
              child: Text(
                "nickname".tr,
                style: textStyleRegular,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: itemSizeSingle,
              child: Text(
                "level".tr,
                style: textStyleRegular,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: itemSizeDouble,
              child: Text(
                "answers".tr,
                style: textStyleRegular,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ).marginSymmetric(horizontal: 8.0),
            SizedBox(
              width: itemSizeDouble,
              child: Text(
                "correct".tr,
                style: textStyleRegular,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 24.0).marginSymmetric(vertical: 16.0),
      ],
    );
  }

  Widget buildList() {
    return GetBuilder<HomeContentController>(
      id: "leader_board",
      builder: (_) {
        return FutureBuilder<LeaderBoardDataResponse>(
          future: controller.loadTopThreeScorer,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return buildItem(
                    snapshot.data!.items[index],
                    index,
                  );
                },
                separatorBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return SizedBox(height: 12.0);
                },
                itemCount: snapshot.data!.items.length,
              );
            } else if (snapshot.hasError) {
              return CentralErrorPlaceholder(
                message: "${snapshot.error}",
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: const CentralProgressIndicator(),
            );
          },
        );
      },
    );
  }

  Widget buildItem(User item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          const Radius.circular(12.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8.0, top: 4.0),
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Center(
                  child: Image.asset(
                    "images/ic_cat.png",
                    fit: BoxFit.contain,
                    height: 40.0,
                  ),
                ),
              ),
              Container(
                width: 24.0,
                height: 24.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("images/ic_background_avatar_tag.png"),
                  ),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: textStyleSmall.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.name}",
                  style: textStyleRegular.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).marginOnly(bottom: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 16.0,
                      width: 16.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: SvgPicture.network(
                          item.countryFlag,
                          fit: BoxFit.cover,
                          semanticsLabel: item.country,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${item.country}",
                        style: textStyleBottomBarItem.copyWith(
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ).marginOnly(left: 8.0),
                    ),
                  ],
                ),
              ],
            ).marginSymmetric(horizontal: 12.0),
          ),
          SizedBox(
            width: itemSizeSingle,
            child: Text(
              "${item.currentLevel}",
              style: textStyleRegular.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: itemSizeDouble,
            child: Text(
              "${item.totalWrongAnswer! + item.totalCorrectAnswer!}",
              style: textStyleRegular.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ).marginSymmetric(horizontal: 8.0),
          SizedBox(
            width: itemSizeDouble,
            child: Text(
              "${item.totalCorrectAnswer}",
              style: textStyleRegular.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
