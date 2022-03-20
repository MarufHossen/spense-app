import 'dart:convert';

import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/product/product.dart';
import 'package:spense_app/util/helper/text.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:get/get.dart';

class LocalService extends GetxService {
  final double baseLevelFactor = 1.1;
  final int numeratorFactor = 11;
  final int denominatorFactor = 10;
  final int baseLevelPoint = 55000;

  late PreferenceUtil _preferenceUtil;

  @override
  void onInit() {
    _preferenceUtil = PreferenceUtil.on;
    super.onInit();
  }

  int getCurrentLevel(int point) {
    return _getCurrentLevel(point.toDouble());
  }

  int _getCurrentLevel(double point) {
    if (point < baseLevelPoint) {
      return 1;
    } else {
      return 1 +
          _getCurrentLevel((point / numeratorFactor) * denominatorFactor);
    }
  }

  int getNextLevel(int point) {
    return _getCurrentLevel(point.toDouble()) + 1;
  }

  int getLevelStartingPoint(int level) {
    if (level == 1) {
      int point = 0; // for level 1
      return point;
    } else {
      int point = 55000; // for level 2
      double tempPoint = point.toDouble();

      // for level 3 and on
      for (int i = 3; i <= level; i++) {
        tempPoint = tempPoint * baseLevelFactor;
      }

      point = tempPoint.toInt();

      return point;
    }
  }

  Future<void> storeInAppProducts(List<Product> products) async {
    return _preferenceUtil.write<String>(
      keyInAppProducts,
      jsonEncode(products
          .map<Map<String, dynamic>>(
            (product) => product.toJson(),
          )
          .toList()),
    );
  }

  List<Product> getInAppProducts() {
    final encodedList = _preferenceUtil.read<String>(
      keyInAppProducts,
      defaultValue: defaultString,
    )!;

    return TextUtil.isNotEmpty(encodedList)
        ? ((jsonDecode(encodedList) as List<dynamic>?)
                ?.map<Product>((item) => Product.fromJson(item))
                .toList() ??
            [])
        : [];
  }
}
