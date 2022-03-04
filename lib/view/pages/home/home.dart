// ignore_for_file: prefer_const_constructors

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:spense_app/view/pages/cashback/cashback_page.dart';
import 'package:spense_app/view/pages/store/store_page.dart';

import '../../../controller/sidebar_controller.dart';
import '../../../enums/booking_status_enum.dart';
import '../../../view/pages/booking/booking_info.dart';
import 'package:flutter/material.dart';
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
    Icons.assignment_outlined,
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
                    StorePage(),
                    BookingInfo(status: BookingStatus.completed),
                    BookingInfo(),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                // isExtended: true,

                child: const Icon(Icons.qr_code_2, color: Colors.black54),
                backgroundColor: Theme.of(context).primaryColor,

                onPressed: () {
                  // sidebarController.setPageIndex(
                  //     sidebarController.selectedPageIndex == 0 ? 1 : 0);
                },
              ));
        });
  }
}
