import 'package:spense_app/view/pages/coupons_tab/coupons_tab.dart';

import '../../../constants.dart';
import 'package:flutter/material.dart';

class CashBackPage extends StatefulWidget {
  const CashBackPage({Key? key}) : super(key: key);

  @override
  _CashBackPageState createState() => _CashBackPageState();
}

class _CashBackPageState extends State<CashBackPage> {
  @override
  Widget build(BuildContext context) {
    // QRScanController parcelController = Get.put(QRScanController());

    return DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: AppBarIconButton(
              icon: Icons.chevron_left_rounded,
              onPressed: () {},
            ),
            actions: [
              AppBarIconButton(
                icon: Icons.search_rounded,
                onPressed: () {},
              ),
              AppBarIconButton(
                icon: Icons.notes_rounded,
                onPressed: () {},
              ),
              const SizedBox(width: 12.0),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight + 8.0),
              child: Theme(
                data: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent),
                child: TabBar(
                    indicator: const BoxDecoration(),
                    labelPadding: kTabLabelPadding.copyWith(bottom: 8.0),
                    labelStyle: cTabTextStyle,
                    labelColor: cTextColor,
                    unselectedLabelColor: cLightColor,
                    tabs: [
                      const Tab(text: "Loyality Cards"),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Coupons"),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Container(
                              height: 22.0,
                              width: 22.0,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFECBC61),
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Center(
                                child: Text(
                                  "2",
                                  style: cTabTextStyle.copyWith(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [Container(), const CouponsTab()],
          ),
        ));
  }
}

class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;
  const AppBarIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: cLightColor,
        size: 28.0,
      ),
      onPressed: onPressed,
    );
  }
}
