import 'package:spense_app/data/remote/model/country/country.dart';

class CountryDataResponse {
  late List<Country> items;

  CountryDataResponse.fromJson(List<dynamic> json) {
    items =
        (json).map((e) => Country.fromJson(e as Map<String, dynamic>)).toList();
  }
}
