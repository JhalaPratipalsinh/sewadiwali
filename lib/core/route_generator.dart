import 'package:flutter/material.dart';

import '../screens/addFoodCollection/addfoodcollection_page.dart';
import '../screens/addGalleryScreen/add_gallery_screen.dart';
import '../screens/authScreen/forgotPassword/forgot_password_screen.dart';
import '../screens/authScreen/login/login_page.dart';
import '../screens/changePasswordScreen/change_password_screen.dart';
import '../screens/home/home_page.dart';
import '../screens/splash_page.dart';
import '../util/constants.dart';

// ignore: avoid_classes_with_only_static_members
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case addFoodPage:
        return MaterialPageRoute(builder: (_) => const AddFoodCollectionPage());
      case addGalleryPage:
        return MaterialPageRoute(builder: (_) => const AddGalleryScreen());
      case changePasswordPage:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case forgotPasswordPage:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
