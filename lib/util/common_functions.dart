import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

enum ImageType {
  appIcon,
  logo,
  checkIcon,
  kidAvatar,
  kidIcon,
  quizIcon,
  testIcon,
  coachIcon
}

class CommonFunctions {
  static const String _icon = 'assets/icon';
  static const String pdfHeaderImage = 'assets/icon/logo.jpg';

  const CommonFunctions();

  void showSnackBar(
      {required BuildContext context,
      required String message,
      required Color bgColor,
      required Color textColor,
      int duration = 3}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor,
        textColor: textColor,
        fontSize: 16.0);
  }

  String getImage(ImageType imageType) {
    if (imageType == ImageType.logo) {
      return '$_icon/logo.jpg';
    } else if (imageType == ImageType.checkIcon) {
      return "$_icon/check_icon.png";
    } else if (imageType == ImageType.kidAvatar) {
      return "$_icon/kid_avatar.png";
    } else if (imageType == ImageType.kidIcon) {
      return "$_icon/kid_icon.png";
    } else if (imageType == ImageType.quizIcon) {
      return "$_icon/quiz_icon.png";
    } else if (imageType == ImageType.testIcon) {
      return "$_icon/test_icon.svg";
    } else if (imageType == ImageType.coachIcon) {
      return "$_icon/coach_icon.png";
    } else if (imageType == ImageType.appIcon) {
      return "$_icon/app_icon.png";
    }

    return "";
  }

  String convertDateToDDMMMYYYY(String dateTime) {
    final DateTime dt1 = DateFormat('yyyy-MM-dd').parse(dateTime);
    final String expDateNew = DateFormat('dd MMM yyyy').format(dt1);
    return expDateNew;
  }

  void openAnyUrl(String strUrl) async {
    var url = Uri.parse(strUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
      // throw 'Could not launch $url';
    }
  }
}
