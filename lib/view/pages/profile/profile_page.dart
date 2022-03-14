import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spense_app/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30),
      child: ListView(
        children: [
          const Text("Maruf Hossen", style: textStyleHeadline),
          // SizedBox(
          //   height: 10,
          // ),
          const Text("+37253633471", style: textStyleRegular),
          const SizedBox(
            height: 15,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: const [
                Icon(Icons.payment, size: 25),
                SizedBox(width: 15),
                Text("Payment", style: textStyleLarge)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: const [
                Icon(Icons.settings_outlined, size: 25),
                SizedBox(width: 15),
                Text("Settings", style: textStyleLarge)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: const [
                Icon(Icons.info_outline, size: 25),
                SizedBox(width: 15),
                Text("About", style: textStyleLarge)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              children: const [
                Icon(Icons.logout_outlined, size: 25),
                SizedBox(width: 15),
                Text("Log out", style: textStyleLarge)
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
