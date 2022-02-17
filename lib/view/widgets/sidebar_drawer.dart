import '../../constants.dart';
import '../../controller/sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SidebarController sidebarController = Get.put(SidebarController());
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: colorPrimary),
            child: Center(
                child: Text('Bullet Express',
                    style: TextStyle(color: Colors.white, fontSize: 25))),
          ),
          ListTile(
            title: const Text('Pending'),
            leading: const Icon(Icons.pending),
            onTap: () {
              sidebarController.setPageIndex(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Completed'),
            leading: const Icon(Icons.done_all_outlined),
            onTap: () {
              sidebarController.setPageIndex(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Printed Bookings'),
            leading: const Icon(Icons.ac_unit),
            onTap: () {
              sidebarController.setPageIndex(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('History'),
            leading: const Icon(Icons.history),
            onTap: () {
              sidebarController.setPageIndex(4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Devices'),
            leading: const Icon(Icons.print),
            onTap: () {
              sidebarController.setPageIndex(5);
              Navigator.pop(context);
            },
          ),
          // ListTile(
          //   title: const Text('Switch Theme'),
          //   leading: const Icon(Icons.change_circle),
          //   onTap: () {
          //     if (Get.isDarkMode) {
          //       Get.changeThemeMode(ThemeMode.light);
          //     } else {
          //       Get.changeThemeMode(ThemeMode.dark);
          //     }

          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
