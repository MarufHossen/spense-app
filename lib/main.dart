import 'package:spense_app/view/pages/cashback/cashback_page.dart';

import './theme/themes.dart';
import './view/pages/auth/login.dart';
import './view/pages/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
