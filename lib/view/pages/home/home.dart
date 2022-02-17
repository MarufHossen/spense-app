// ignore_for_file: prefer_const_constructors

import '../../../controller/sidebar_controller.dart';
import '../../../enums/booking_status_enum.dart';
import '../../../view/pages/booking/booking_info.dart';
import '../../../view/pages/devices/device_page.dart';
import '../../../view/pages/scan/qr_scan.dart';
import '../../../view/pages/scan_history/scan_history.dart';
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
  SidebarController sidebarController = Get.put(SidebarController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SidebarController>(builder: (sidebarController) {
      return Scaffold(
          appBar: AppBar(
            title: sidebarController.getSelectedPageTitle(),
            actions: <Widget>[
              FutureBuilder(
                  future: sidebarController.getCurrentAddress(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Placemark> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white));
                        }
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Center(
                              child: Text(
                                // snapshot.data!.street.toString() +
                                //     ", " +
                                snapshot.data!.locality.toString(),
                              ),
                            ),
                          );
                        }
                        break;
                      default:
                        return const Center(child: Text("Loading"));
                    }

                    return Center(child: Text("Loading"));
                    // if (!snapshot.hasData) {
                    //   return const Center(child: CircularProgressIndicator());
                    // } else {
                    //   return Center(
                    //       child: Text(snapshot.data!.street.toString()));
                    // }
                  }),
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      sidebarController.getCurrentAddress();
                    },
                    child: const Icon(Icons.my_location),
                  )),
            ],
          ),
          // bottomNavigationBar: const CustomerBottomNavBar(),
          drawer: const SidebarDrawer(),
          body: SafeArea(
            child: IndexedStack(
              index: sidebarController.selectedPageIndex,
              children: const [
                QRScanPage(),
                BookingInfo(status: BookingStatus.pending),
                BookingInfo(status: BookingStatus.completed),
                BookingInfo(),
                ScanHistory(),
                DevicePage()
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: sidebarController.selectedPageIndex == 0
                ? const Icon(
                    Icons.arrow_back,
                  )
                : const Icon(Icons.qr_code_2),
            backgroundColor: Theme.of(context).primaryColor,

            onPressed: () {
              sidebarController.setPageIndex(
                  sidebarController.selectedPageIndex == 0 ? 1 : 0);
            },
          ));
    });
  }
}
