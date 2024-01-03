import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FileUtils on File {
  get size {
    int sizeInBytes = lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  double getFileSizeInMB() {
    int sizeInBytes = lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }
}

//create custom Colors
MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = <int, Color>{};
  // ignore: avoid_multiple_declarations_per_line
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  // ignore: avoid_function_literals_in_foreach_calls

  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

//Http Requests Base url and End Points

// ignore: constant_identifier_names
const CLIENT_ID = '964de1d6-590d-4455-94fd-5a96bdb53df7';
// ignore: constant_identifier_names
const CLIENT_SECRET = 'Z1WE08cIoI66s4pHArle5H8awfUSszumw1UxU70V';
//Live url
//const baseURL = 'https://dev.kreedatantra.com/';
//Staging url
const baseURL = 'https://sewadiwali.org/';

// ignore: constant_identifier_names
const baseURLEndPoint = '${baseURL}manage/API/';
// ignore: constant_identifier_names
const imgBaseURL = '${baseURL}storage/';

const coachImgUrl = '${imgBaseURL}coach_profiles/';
const studentImgUrl = '${imgBaseURL}student_profiles/';
const assessmentIconUrl = '${imgBaseURL}assessment_icons/';
const activityImageUrl = '${imgBaseURL}activity_image/';

/*API Base Urls*/
const loginAPI = '${baseURLEndPoint}login';
const homeAPI = '${baseURLEndPoint}mobileHome';
const getCenterAndPantryAPI =
    '${baseURLEndPoint}addCollectedFood/getcenterandpantry';
const addFoodCollectionAPI = '${baseURLEndPoint}AddCollectedFood';
const addGalleryAPI = '${baseURLEndPoint}UploadGallery';
const changePasswordAPI = '${baseURLEndPoint}ForgotPassword/changepassword';
const forgotPasswordAPI = '${baseURLEndPoint}ForgotPassword';
const stateListAPI = '${baseURLEndPoint}State_list';

/*Route Names*/
const splashScreen = '/';
const loginPage = '/loginPage';
const homePage = '/homePage';
const addFoodPage = '/addFoodCollectionPage';
const addGalleryPage = '/addGalleryPage';
const changePasswordPage = '/changePasswordPage';
const forgotPasswordPage = '/forgotPasswordPage';

//Session value keys
const userData = 'user_data';
const isLoggedIn = 'is_logged_in';

const fontRegular = 'font/quicksand_regular.ttf';
const fontbold = 'font/quicksand_bold.ttf';

final dateAndTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
final dateAndTimeDDMMMYYYYFormat = DateFormat('dd MMM yyyy');
final dateMMDDYYYYFormat = DateFormat('MM-dd-yyyy');
