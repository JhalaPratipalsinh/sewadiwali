// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sewadiwali/util/common_functions.dart';

import '../../core/color_constants.dart';
import '../../injection_container.dart';
import '../string_resources.dart';

class AlertHelper {
  static AlertHelper? instance;

  static AlertHelper? getInstance() {
    instance ??= AlertHelper();

    return instance;
  }

  void error({
    required BuildContext context,
    String title = 'Something Went Wrong!',
    String desc = '',
  }) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: desc,
    ).show();
  }

  void success({
    required BuildContext context,
    String title = 'Successfully Completed!',
    String desc = '',
    String label = 'SUBMIT',
    VoidCallback? onPressed,
  }) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  void confirmation({
    required BuildContext context,
    String title = 'Saint Mina Church',
    String desc = '',
    String label = 'YES',
    VoidCallback? onPressed,
  }) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      style: const AlertStyle(
          animationType: AnimationType.shrink,
          animationDuration: Duration(milliseconds: 100),
          backgroundColor: Colors.white),
      desc: desc,
      buttons: [
        DialogButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          color: Colors.red,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () => Navigator.pop(context),
          color: ColorConstants.colorPrimaryDark,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  void materialSelection({
    required BuildContext context,
    Widget? content,
    String title = 'Select Material',
    String desc = '',
    String label = 'Done',
    VoidCallback? onPressed,
  }) {
    Alert(
      context: context,
      // image: const Icon(Icons.translate),
      title: title,
      style: const AlertStyle(
          animationType: AnimationType.shrink,
          animationDuration: Duration(milliseconds: 100)),
      desc: desc,
      content: content ?? const SizedBox(),
    ).show();
  }

  void custom({
    required BuildContext context,
    required Widget content,
    String title = 'Forgot Your Password?',
    String label = 'SUBMIT',
    VoidCallback? onPressed,
  }) {
    Alert(
      context: context,
      title: title,
      content: content,
      buttons: [
        DialogButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  Future<void> showImagePickerAlert({
    required BuildContext context,
    String title = 'Select from',
    String desc = '',
    String cameraLabel = 'Take Photo',
    String galleryLabel = 'Choose from gallery',
    Function(bool isCamera)? onPressed,
  }) async {
    // final permissions = await [Permission.camera, Permission.storage].request();
    // Permission.camera.request;
    // Permission.storage.request;
    Alert(
      context: context,
      // type: AlertType.info,
      title: title,
      desc: desc,
      style: const AlertStyle(buttonsDirection: ButtonsDirection.column),
      buttons: [
        DialogButton(
          onPressed: () async {
            // Request camera and storage permissions
            final permissions = await [
              Permission.camera,
              Permission.mediaLibrary,
              Permission.manageExternalStorage,
              Permission.photos
            ].request();

            print("Camera Permission - ${permissions[Permission.camera]}");
            if (await Permission.camera.isGranted == true) {
              Navigator.of(context).pop();
              onPressed!(true);
            } else if (await Permission.camera.isDenied == true ||
                await Permission.camera.isPermanentlyDenied == true) {
              sl<CommonFunctions>().showSnackBar(
                  context: context,
                  message: StringResources.cameraPermission,
                  bgColor: ColorConstants.red,
                  textColor: Colors.white);
              await Future.delayed(const Duration(seconds: 1));
              await AppSettings.openAppSettings(type: AppSettingsType.settings);
            } else {
              sl<CommonFunctions>().showSnackBar(
                  context: context,
                  message: StringResources.cameraPermission,
                  bgColor: ColorConstants.red,
                  textColor: Colors.white);
            }
          },
          color: ColorConstants.colorAccent,
          child: Text(
            cameraLabel,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () async {
            // Request camera and storage permissions

            if (Platform.isAndroid) {
              final permissions = await [
                Permission.manageExternalStorage,
                Permission.photos,
                Permission.storage,
                Permission.mediaLibrary
              ].request();

              print("Storage Permission - ${permissions[Permission.storage]}");

              // Check if permissions were granted
              final deviceInfo = await DeviceInfoPlugin().androidInfo;
              if (await Permission.photos.isGranted == true &&
                  deviceInfo.version.sdkInt > 32) {
                Navigator.of(context).pop();
                onPressed!(false);
              } else if (await Permission.storage.isGranted == true) {
                Navigator.of(context).pop();
                onPressed!(false);
              } else {
                sl<CommonFunctions>().showSnackBar(
                    context: context,
                    message: StringResources.galleryPermission,
                    bgColor: ColorConstants.red,
                    textColor: Colors.white);
                await Future.delayed(const Duration(seconds: 1));
                await AppSettings.openAppSettings(
                    type: AppSettingsType.settings);
              }
            } else {
              final permissions = await [
                Permission.photos,
                Permission.storage,
                Permission.mediaLibrary
              ].request();

              print("Storage Permission - ${permissions[Permission.storage]}");

              // Check if permissions were grant
              if (await Permission.photos.isGranted == true) {
                Navigator.of(context).pop();
                onPressed!(false);
              } else if (await Permission.storage.isDenied == true ||
                  await Permission.storage.isPermanentlyDenied == true) {
                sl<CommonFunctions>().showSnackBar(
                    context: context,
                    message: StringResources.galleryPermission,
                    bgColor: ColorConstants.red,
                    textColor: Colors.white);
                await Future.delayed(const Duration(seconds: 1));
                await AppSettings.openAppSettings(
                    type: AppSettingsType.settings);
              } else {
                sl<CommonFunctions>().showSnackBar(
                    context: context,
                    message: StringResources.galleryPermission,
                    bgColor: ColorConstants.red,
                    textColor: Colors.white);
                await Future.delayed(const Duration(seconds: 1));
                await AppSettings.openAppSettings(
                    type: AppSettingsType.settings);
              }
            }
          },
          color: ColorConstants.colorAccent,
          child: Text(
            galleryLabel,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          color: ColorConstants.appColor,
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }
}
