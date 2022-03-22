import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spense_app/base/widget/central_error_placeholder.dart';
import 'package:spense_app/base/widget/central_progress_indicator.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/data/remote/response/profile_response.dart';
import 'package:spense_app/ui/profile/view/view_profile_controller.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../constants.dart';

class ViewProfilePage extends GetView<ViewProfileController> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal.copyWith(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: colorPageBackground,
        extendBodyBehindAppBar: true,
        body: FutureBuilder<ProfileResponse>(
          future: RemoteRepository.on().getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.coins != null) {
                PreferenceUtil.on.write<int>(keyCoins, snapshot.data!.coins!);
              }

              if (snapshot.data!.gems != null) {
                PreferenceUtil.on.write<int>(keyGems, snapshot.data!.gems!);
              }

              if (snapshot.data!.totalEarnedPoints != null) {
                PreferenceUtil.on.write<int>(
                  keyTotalEarnedPoints,
                  snapshot.data!.totalEarnedPoints!,
                );
              }

              controller.calculateStatistics(snapshot.data!);

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: buildMainBody(snapshot),
                  ),
                ],
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
    );
  }

  Widget buildMainBody(AsyncSnapshot<ProfileResponse> snapshot) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              buildInformationSection(snapshot.data!),
              buildCreditSection(snapshot.data!),
            ],
          ),
          buildStatisticsSection(snapshot.data!),
          buildRankSection(snapshot.data!),
        ],
      ),
    );
  }

  Container buildInformationSection(ProfileResponse data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 38.0),
      padding: const EdgeInsets.only(
        bottom: 56.0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            "images/ic_background_profile_user_avatar.png",
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*TODO: Remove the below comment if,
                     settings and edit options are needed later*/
                  /*IconButton(
                    icon: Image.asset(
                      "images/ic_settings.png",
                      height: 24.0,
                      fit: BoxFit.fitHeight,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Image.asset(
                      "images/ic_edit.png",
                      height: 24.0,
                      fit: BoxFit.fitHeight,
                    ),
                    onPressed: () {},
                  ),*/
                  IconButton(
                    icon: Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      controller.logOut();
                    },
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: const Border.fromBorderSide(
                      const BorderSide(
                        color: Colors.white,
                        width: 4.0,
                      ),
                    ),
                  ),
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset(
                        "images/ic_cat.png",
                        fit: BoxFit.contain,
                        height: 80.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(12.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    controller.currentLevel!.toString(),
                    style: textStyleRegular,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              "${data.name}",
              style: textStyleFocused.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ).marginOnly(top: 12.0, bottom: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 16.0,
                  width: 16.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: SvgPicture.network(
                      data.countryFlag!,
                      fit: BoxFit.cover,
                      semanticsLabel: data.country,
                    ),
                  ),
                ),
                Text(
                  "${data.country}",
                  style: textStyleFocused.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ).marginOnly(left: 8.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildCreditSection(ProfileResponse data) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(12.0),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  "images/ic_gem.png",
                  height: 32.0,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(width: 16.0),
                Text(
                  "${data.gems}\n" + 'profile_gems'.tr,
                  style: textStyleFocused,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  "images/ic_coin.png",
                  height: 32.0,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(width: 16.0),
                Text(
                  "${data.coins}\n" + 'profile_coins'.tr,
                  style: textStyleFocused,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildStatisticsSection(ProfileResponse data) {
    final pointPercentage =
        controller.currentPoint! / controller.nextLevelStartingBoundary!;

    return Container(
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(12.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile_your_statistics'.tr,
            style: textStyleSectionTitle,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              LinearPercentIndicator(
                animation: false,
                lineHeight: 32.0,
                padding: const EdgeInsets.only(left: 22.0, right: 16.0),
                percent: pointPercentage > 1.0 ? 1.0 : pointPercentage,
                center: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.currentPoint!.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      " / ${controller.nextLevelStartingBoundary!.toString()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0,
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
          ).marginSymmetric(vertical: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: buildStatisticsItem(
                  'profile_earned_coins'.tr,
                  "${data.totalEarnedPoints}",
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: buildStatisticsItem(
                  'profile_correct'.tr,
                  "${data.totalCorrectAnswer}",
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: buildStatisticsItem(
                  'profile_wrong'.tr,
                  "${data.totalWrongAnswer}",
                ),
              ),
            ],
          ),
        ],
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
        ).marginOnly(bottom: 4.0),
        Text(
          title,
          style: textStyleSectionItemTitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Container buildRankSection(ProfileResponse data) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(12.0),
        ),
        color: colorHighlight,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("images/ic_background_profile_rank.png"),
        ),
      ),
      child: Row(
        children: [
          Text(
            'profile_your_rank'.tr,
            style: textStyleSectionTitle.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              "${data.rank}",
              style: textStyleSectionTitle.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
