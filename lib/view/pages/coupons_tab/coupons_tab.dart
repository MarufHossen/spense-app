import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/model/coupon.dart';
import 'package:spense_app/model/discover.dart';
import 'package:spense_app/view/pages/category/category_page.dart';
import 'package:spense_app/view/pages/expanded_coupons/expanded_coupons.dart';
import 'components/coupon_card.dart';
import 'components/discover_card.dart';
import 'components/sliver_persistent_header.dart';

class CouponsTab extends StatefulWidget {
  const CouponsTab({Key? key}) : super(key: key);

  @override
  _CouponsTabState createState() => _CouponsTabState();
}

class _CouponsTabState extends State<CouponsTab> {
  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  double discoverOpacity = 1.0;

  void _scrollListener() {
    setState(() {
      scrollOffset = scrollController.offset;
      discoverOpacity = ((scrollController.offset - 216) / -58).clamp(0.0, 1.0);
    });
  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Discover
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(cPadding),
                child: Row(children: [
                  Text("Discover", style: cHeaderTextStyle),
                  const Spacer(),
                  TextButton(
                    child: Text(
                      "View all",
                      style: cTextStyle,
                    ),
                    onPressed: () => {Get.to(const CategoryPage())},
                  ),
                  Icon(Icons.navigate_next, size: 16.0, color: cLightColor)
                ]),
              ),
              Opacity(
                opacity: discoverOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: cPadding),
                  child: SizedBox(
                    height: 164.0,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: cPadding),
                      scrollDirection: Axis.horizontal,
                      itemCount: discoverList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 12.0,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            width: 148.0,
                            child: DiscoverCard(discoverList[index]));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // My Coupons
        SliverPersistentHeader(
          pinned: true,
          delegate: HeaderDelegate("My Coupons"),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(cPadding).add(
              EdgeInsets.only(bottom: cPadding + cFloatingActionButtonHeight)),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext buildContext, int index) {
              const itemHeight = 136.0;
              const heightFactor = 0.8;

              final itemPositionOffset = index * itemHeight * heightFactor;
              final difference = (scrollOffset - 240) - itemPositionOffset;
              final percent = 1.0 - (difference / (itemHeight * heightFactor));

              final result = percent.clamp(0.0, 1.0);

              return Align(
                heightFactor: heightFactor,
                child: SizedBox(
                  height: itemHeight,
                  child: Transform.scale(
                    scale: result,
                    alignment: const Alignment(0.0, 0.56),
                    child: Opacity(
                      opacity: result,
                      child: CouponCard(
                          coupon: couponsList[index],
                          context: buildContext,
                          index: index,
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return ExpandedCoupons(
                                      index, context, animation);
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 100),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 100)));
                          }),
                    ),
                  ),
                ),
              );
            },
            childCount: couponsList.length,
          )),
        ),
      ],
    );
  }
}
