import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:sewadiwali/core/color_constants.dart';
import 'package:sewadiwali/data/sessionManager/session_manager.dart';
import 'package:sewadiwali/screens/home/widget/grid_box_widget.dart';
import 'package:sewadiwali/util/image_resources.dart';
import 'package:sewadiwali/util/string_resources.dart';

import '../injection_container.dart';
import '../util/constants.dart';
import 'basicWidget/loading_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isChecking = true;

  List<GridData> options = [];

  @override
  void initState() {
    super.initState();

    options = [
      GridData(
        title: "Add Collected Food",
        icon: Icons.food_bank_outlined,
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.of(context).pushNamed(loginPage);
        },
      ),
      GridData(
        title: "Upload Photos",
        icon: Icons.photo,
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.pushNamed(context, addGalleryPage);
        },
      ),
    ];
    /*Timer(
      const Duration(seconds: 2),
      () => sl<SessionManager>().isUserLoggedIn()
          ? Navigator.pushReplacementNamed(context, homePage)
          : Navigator.pushReplacementNamed(context, loginPage),
    );*/
    checkForUpdate();
  }

  void navigateUser() async {
    await Future.delayed(const Duration(seconds: 2), () {
      final loginData = sl<SessionManager>().getUserDetails();
      if (loginData != null) {
        Navigator.pushNamedAndRemoveUntil(context, homePage, (route) => false);
      } else {
        isChecking = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            ImageResources.splashbgfinal,
            width: double.infinity, // Adjust the width as needed
            height: double.infinity,
            fit: BoxFit.fill, // Adjust the height as needed
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  // Set the background color with 50% opacity
                  borderRadius: BorderRadius.circular(
                      15), // Adjust the radius to control the roundness
                ),
                child: Text(
                  StringResources.appName,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontbold,
                    color: ColorConstants.textColor1,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: isChecking
                    ? const LoadingWidget()
                    : GridView.builder(
                        itemCount: options.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (ctx, index) => GridBoxWidget(
                          data: options[index],
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 5),
                      ),
                // : Column(
                //     children: [
                //       Text(
                //         "Login",
                //         style: TextStyle(
                //           fontSize:
                //               MediaQuery.of(context).size.width * 0.08,
                //           fontWeight: FontWeight.bold,
                //           fontFamily: fontbold,
                //           color: ColorConstants.textColor1,
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //       Text(
                //         "Only authorize user can login",
                //         style: TextStyle(
                //           fontSize:
                //               MediaQuery.of(context).size.width * 0.04,
                //           fontWeight: FontWeight.normal,
                //           fontFamily: fontRegular,
                //           color: ColorConstants.textColor2,
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //       SizedBox(
                //         height: 55,
                //         child: ButtonWidget(
                //             buttonText: 'Click to Login',
                //             onPressButton: () {
                //               Navigator.of(context).pushNamed(loginPage);
                //             },
                //             buttonRadius: 5,
                //             fontSize: 16),
                //       ),
                //       const SizedBox(height: 10),
                //       SizedBox(
                //         height: 55,
                //         child: ButtonWidget(
                //           buttonText: 'Click to Skip',
                //           onPressButton: () {
                //             Navigator.of(context).pushNamed(homePage);
                //           },
                //           fontSize: 16,
                //           buttonRadius: 5,
                //           isBorder: true,
                //         ),
                //       ),
                //     ],
                //   ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myCard({required GridData data, Function()? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 3,
        color: data.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, size: 40, color: Colors.white),
              const SizedBox(
                height: 10,
              ),
              Text(data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate().catchError((e) {
            // navigateToNextScreen();
            navigateUser();
            print(e.toString());
            return AppUpdateResult.inAppUpdateFailed;
          });
        } else {
          navigateUser();
        }
      });
    }).catchError((e) {
      navigateUser();
      // navigateToNextScreen();
      print(e.toString());
    });
  }
}

class GridData {
  Color backgroundColor;
  String title;
  IconData icon;
  Function()? onPressed;

  GridData(
      {required this.title,
      required this.icon,
      required this.backgroundColor,
      this.onPressed});
}
