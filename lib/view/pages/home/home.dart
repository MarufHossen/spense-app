// ignore_for_file: prefer_const_constructors

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:spense_app/view/pages/cashback/cashback_page.dart';
import 'package:spense_app/view/pages/coupons_tab/coupons_tab.dart';

import '../../../controller/sidebar_controller.dart';
import '../../../enums/booking_status_enum.dart';
import '../../../view/pages/booking/booking_info.dart';
import '../../../view/pages/devices/device_page.dart';
import '../../../view/pages/scan/qr_scan.dart';
import '../../../view/widgets/sidebar_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavIndex = 0;
  List<IconData> iconList = [
    Icons.home,
    Icons.store,
    Icons.history,
    Icons.person,
  ];
  // SidebarController sidebarController = Get.put(SidebarController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SidebarController>(
        init: SidebarController(),
        builder: (sidebarController) {
          return Scaffold(

              // bottomNavigationBar: const CustomerBottomNavBar(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: AnimatedBottomNavigationBar(
                icons: iconList,
                activeIndex: sidebarController.selectedPageIndex,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.defaultEdge,
                // leftCornerRadius: 32,
                // rightCornerRadius: 32,
                onTap: (index) {
                  print(index);
                  sidebarController.setPageIndex(index);
                  setState(() => _bottomNavIndex = index);
                },
                //other params
              ),
              body: SafeArea(
                child: IndexedStack(
                  index: sidebarController.selectedPageIndex,
                  children: const [
                    CashBackPage(),
                    BookingInfo(status: BookingStatus.pending),
                    BookingInfo(status: BookingStatus.completed),
                    BookingInfo(),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                // isExtended: true,
                child: const Icon(Icons.qr_code_2),
                backgroundColor: Theme.of(context).primaryColor,

                onPressed: () {
                  // sidebarController.setPageIndex(
                  //     sidebarController.selectedPageIndex == 0 ? 1 : 0);
                },
              ));
        });
  }
}
