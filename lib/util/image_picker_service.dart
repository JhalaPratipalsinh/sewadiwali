import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../core/color_constants.dart';
import 'string_resources.dart';

class ImagePickerService {
  BuildContext context;
  CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1.6);
  bool isLockRatio = true;
  bool isCanChangeRatio = false;

  ImagePickerService({required this.context});

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickAndCropImage({bool fromCamera = false}) async {
    final pickedFile = fromCamera
        ? await _picker.pickImage(source: ImageSource.camera)
        : await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null; // No image picked
    }
    try {
      // final croppedFile = await ImageCropper().cropImage(
      //   sourcePath: pickedFile.path,
      //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Make it square
      //   maxWidth: 200,
      //   maxHeight: 200,
      // );
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: aspectRatio,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: StringResources.appName,
              toolbarColor: ColorConstants.colorPrimaryDark,
              toolbarWidgetColor: Colors.yellow,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: isLockRatio),
          IOSUiSettings(
            title: StringResources.appName,
            resetAspectRatioEnabled: isCanChangeRatio, // change ratio button
            aspectRatioLockEnabled: isLockRatio,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } catch (e) {
      print('Error during cropping: $e');
      // Handle the error gracefully, e.g., display an error message to the user.
    }

    return null; // Cropping canceled or failed
  }
}
