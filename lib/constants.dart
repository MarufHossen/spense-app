import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// App colors (main)
const Color colorPrimary = Color(0xFFef233c);
const Color colorAccent = Color(0xFFE9C46A);
const Color colorHighlight = Color(0xFFFFA100);
const Color colorPrimaryDark = Color(0xFF2b2d42);

// App colors (text)
const Color colorTextRegular = Color(0xFF272B37);
const Color colorTextSecondary = Color(0xFF707586);
const Color colorTextTertiary = Color(0xFF6B7285);
const Color colorTextWarning = Color(0xFFFF5E00);

// App colors (others)
const Color colorInputFieldBackground = Color(0xFFFAFAFA);
const Color colorInputFieldBorder = Color(0xFFF3F2F2);
const Color colorPageBackground = Color(0xFFF4F5F7);
const Color colorCloseButtonBackground = Color(0x12707586);

// Text styles
const String appFontFamily = "Nunito";

const TextStyle textStyleLarge = TextStyle(
  color: colorTextRegular,
  fontSize: 16.0,
  fontFamily: appFontFamily,
  fontWeight: FontWeight.w500,
);

const TextStyle textStyleRegular = TextStyle(
  color: colorTextRegular,
  fontSize: 14.0,
  fontFamily: appFontFamily,
  // fontWeight: FontWeight.w700,
);

const TextStyle textStyleSmall = TextStyle(
  color: colorTextRegular,
  fontSize: 12.0,
  fontFamily: appFontFamily,
  fontWeight: FontWeight.w400,
);

const TextStyle textStyleHeadline = TextStyle(
  color: colorTextRegular,
  fontSize: 26.0,
  fontFamily: appFontFamily,
  fontWeight: FontWeight.w700,
);

// Service
const SystemUiOverlayStyle systemUiOverlayStyleGlobal = SystemUiOverlayStyle(
  systemNavigationBarColor: colorPageBackground,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
);

// App essentials
const String responseOfJsonType = "application/json";
const int minimumPasswordLength = 6;
const int minimumVerificationCodeLength = 4;
const String prefixAuthToken = "Bearer ";

// Backend
const String baseApiUrl = 'parcelservice.herokuapp.com';

const String keyIsLoggedIn = "is_logged_in";
const String keyUserId = "user_id";
const String keyId = "id";
const String keyName = "name";

// Regular Expression
const String regularExpressionEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
// const String regularExpressionPhone =
//     "(\\+[0-9]+[\\- \\.]*)?(\\([0-9]+\\)[\\- \\.]*)?" +
//         "([0-9][0-9\\- \\.]+[0-9])";
