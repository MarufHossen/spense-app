import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spense_app/base/widget/central_error_placeholder.dart';
import 'package:spense_app/base/widget/central_progress_indicator.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/user/user.dart';
import 'package:spense_app/data/remote/repository/remote_repository.dart';
import 'package:spense_app/data/remote/response/leader_board_data_response.dart';
import 'package:spense_app/ui/leader_board/leader_board_controller.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class LeaderBoardPage extends GetView<LeaderBoardController> {
  final itemSizeSingle = 35.0;
  final itemSizeDouble = 65.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal.copyWith(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: colorPageBackground,
        extendBodyBehindAppBar: true,
        body: FutureBuilder<LeaderBoardDataResponse>(
          future: RemoteRepository.on().getLeaderBoardData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 270.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "images/ic_background_leader_board.png",
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Nickname",
                                style: textStyleRegular.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: itemSizeSingle,
                              child: Text(
                                "Lvl",
                                style: textStyleRegular.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: itemSizeDouble,
                              child: Text(
                                "Answers",
                                style: textStyleRegular.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ).marginSymmetric(horizontal: 8.0),
                            SizedBox(
                              width: itemSizeDouble,
                              child: Text(
                                "Correct",
                                style: textStyleRegular.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                            .paddingSymmetric(horizontal: 24.0)
                            .marginSymmetric(vertical: 16.0),
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
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
                          ),
                        ),
                      ],
                    ),
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

  Widget buildItem(User item, int index) {
    int? myUserId = PreferenceUtil.on.read<int?>(keyUserId);
    bool isHighlighted = index == 0;
    bool isLightlyHighlighted = myUserId != null && myUserId == item.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: isHighlighted
            ? colorHighlight
            : (isLightlyHighlighted ? colorLightlyHighlight : Colors.white),
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
                    color: isHighlighted ? Colors.white : colorTextRegular,
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
                          color:
                              isHighlighted ? Colors.white : colorTextRegular,
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
                color: isHighlighted ? Colors.white : colorTextRegular,
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
                color: isHighlighted ? Colors.white : colorTextRegular,
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
                color: isHighlighted ? Colors.white : colorTextRegular,
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
