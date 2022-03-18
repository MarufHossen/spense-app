import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/remote/model/country/country.dart';
import 'package:spense_app/data/remote/response/base_response.dart';
import 'package:spense_app/data/remote/response/country_data_response.dart';
import 'package:spense_app/data/remote/response/leader_board_data_response.dart';
import 'package:spense_app/data/remote/response/login_response.dart';
import 'package:spense_app/data/remote/response/product_data_response.dart';
import 'package:spense_app/data/remote/response/profile_response.dart';
import 'package:spense_app/data/remote/response/question_response.dart';
import 'package:spense_app/util/helper/network/api.dart';
import 'package:spense_app/util/lib/preference.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RemoteRepository {
  RemoteRepository._internal();

  static final RemoteRepository _instance = RemoteRepository._internal();

  static RemoteRepository on() {
    if (ApiUtil.client == null) {
      ApiUtil.client = Dio(
        BaseOptions(
          baseUrl: baseApiUrl,
          headers: {
            HttpHeaders.acceptHeader: responseOfJsonType,
          },
        ),
      );

      ApiUtil.client!.interceptors.add(
        PrettyDioLogger(
          requestHeader: kDebugMode,
          requestBody: kDebugMode,
          responseBody: kDebugMode,
          responseHeader: kDebugMode,
        ),
      );
    }

    return _instance;
  }

  // Authentication
  Future<LoginResponse> login(
    String emailAddress,
    String password,
  ) async {
    final response = await ApiUtil.postRequest(
      endPoint: loginUrl,
      data: {
        keyEmail: emailAddress,
        keyPassword: password,
      },
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<BaseResponse> register(
    String name,
    String emailAddress,
    String password,
    Country country,
  ) async {
    final response = await ApiUtil.postRequest(
      endPoint: registrationUrl,
      data: {
        keyEmail: emailAddress,
        keyPassword: password,
        keyName: name,
        keyCountry: country.alpha2Code,
        keyCountryFlag: country.flag,
      },
    );

    return BaseResponse(response.data);
  }

  // Profile
  Future<ProfileResponse> getProfileData() async {
    final response = await ApiUtil.getRequest(
      endPoint: ApiUtil.appendPathIntoPostfix(
        profileUrl,
        PreferenceUtil.on.read<int>(keyUserId)!.toString(),
      ),
    );

    return ProfileResponse.fromJson(response.data);
  }

  // Leader-board
  Future<LeaderBoardDataResponse> getLeaderBoardData({int limit = 20}) async {
    final response = await ApiUtil.getRequest(
      endPoint: ApiUtil.appendPathIntoPostfix(
        leaderBoardUrl,
        limit.toString(),
      ),
    );

    return LeaderBoardDataResponse.fromJson(response.data);
  }

  // Questions
  Future<QuestionResponse> getQuestions() async {
    final url = ApiUtil.appendPathIntoPostfix(
      questionUrl,
      PreferenceUtil.on.read<int>(keyUserId)!.toString(),
    );

    final response = await ApiUtil.getRequest(
      endPoint: ApiUtil.appendPathIntoPostfix(
        url,
        questionUrlSuffix,
      ),
      shouldGetOtherHeaders: false,
    );

    return QuestionResponse.fromJson(response.data);
  }

  Future<ProfileResponse> updateScore(
    int rightAnswers,
    int wrongAnswers,
    int pointToBeAdded,
    List<int> seenQuestionIds,
  ) async {
    final response = await ApiUtil.putRequest(
      endPoint: updatePointUrl,
      data: {
        keyAuthId: PreferenceUtil.on.read<int>(keyUserId)!.toString(),
        keyIncrementAmount: pointToBeAdded.toString(),
        keyCorrectAnswer: rightAnswers.toString(),
        keyWrongAnswer: wrongAnswers.toString(),
        keySeenQuestionIds: seenQuestionIds,
      },
    );

    return ProfileResponse.fromJson(response.data);
  }

  // Coins and Gems
  Future<ProfileResponse> decrementCoin(
    int amount,
  ) async {
    final response = await ApiUtil.putRequest(
      endPoint: decrementCoinUrl,
      data: {
        keyAuthId: PreferenceUtil.on.read<int>(keyUserId)!.toString(),
        keyDecrementAmount: amount.toString(),
      },
    );

    return ProfileResponse.fromJson(response.data);
  }

  Future<ProfileResponse> decrementGem(
    int amount,
  ) async {
    final response = await ApiUtil.putRequest(
      endPoint: decrementGemUrl,
      data: {
        keyAuthId: PreferenceUtil.on.read<int>(keyUserId)!.toString(),
        keyDecrementAmount: amount.toString(),
      },
    );

    return ProfileResponse.fromJson(response.data);
  }

  Future<ProfileResponse> incrementCoin(
    int amount,
  ) async {
    final response = await ApiUtil.putRequest(
      endPoint: incrementCoinUrl,
      data: {
        keyAuthId: PreferenceUtil.on.read<int>(keyUserId)!.toString(),
        keyIncrementAmount: amount.toString(),
      },
    );

    return ProfileResponse.fromJson(response.data);
  }

  Future<ProfileResponse> incrementGem(
    int amount,
  ) async {
    final response = await ApiUtil.putRequest(
      endPoint: incrementGemUrl,
      data: {
        keyAuthId: PreferenceUtil.on.read<int>(keyUserId)!.toString(),
        keyIncrementAmount: amount.toString(),
      },
    );

    return ProfileResponse.fromJson(response.data);
  }

  // Countries
  Future<CountryDataResponse> getCountries() async {
    final response = await ApiUtil.getRequest(
      endPoint: countriesUrl,
      shouldGetOtherHeaders: false,
    );

    return CountryDataResponse.fromJson(response.data);
  }

  // In app products
  Future<ProductDataResponse> getInAppProducts() async {
    final response = await ApiUtil.getRequest(
      endPoint: productsUrl,
    );

    return ProductDataResponse.fromJson(response.data);
  }
}
