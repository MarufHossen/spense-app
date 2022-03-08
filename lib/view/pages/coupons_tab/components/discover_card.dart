import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:spense_app/constants.dart';
import 'package:spense_app/model/discover.dart';
import 'package:spense_app/view/pages/store/store_page.dart';

class DiscoverCard extends StatelessWidget {
  final Discover discover;
  const DiscoverCard(this.discover, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(const StorePage()),
      child: Card(
        margin: EdgeInsets.zero,
        color: discover.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: cCardBorderRadius),
        child: Stack(
          children: [
            DiscoverCardShadow(
                xTranslate: 0,
                yTranslate: -86,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.04)
                    ])),
            DiscoverCardShadow(
                xTranslate: 48,
                yTranslate: 48,
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.02)
                    ])),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discover.title,
                    style: cTextStyle.copyWith(
                        fontSize: 16.0,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    discover.couponsCount.toString() + " coupons",
                    style:
                        cTextStyle.copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      discover.icon,
                      size: 32.0,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DiscoverCardShadow extends StatelessWidget {
  final double xTranslate;
  final double yTranslate;
  final Gradient gradient;
  const DiscoverCardShadow(
      {required this.xTranslate,
      required this.yTranslate,
      required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: Offset(xTranslate, yTranslate),
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: gradient)),
        ),
      ),
    );
  }
}
