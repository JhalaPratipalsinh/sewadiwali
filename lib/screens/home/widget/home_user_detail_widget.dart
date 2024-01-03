import 'package:flutter/material.dart';
import 'package:sewadiwali/core/color_constants.dart';

import '../../../data/sessionManager/session_manager.dart';
import '../../../injection_container.dart';
import '../../../util/image_resources.dart';

class HomeUserDetailWidget extends StatelessWidget {
  const HomeUserDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loginData = sl<SessionManager>().getUserDetails();
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage(ImageResources
                  .userAvtar), // Replace with the actual avatar URL
            ),
            const SizedBox(width: 16.0),
            loginData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${loginData.firstName} ${loginData.lastName}", // Replace with the user's name
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        loginData.name, // Replace with the user's email
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ColorConstants.appColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: ColorConstants.appColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
