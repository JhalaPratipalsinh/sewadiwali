import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sewadiwali/util/string_extension.dart';
import '../core/color_constants.dart';
import 'image_resources.dart';

class CustomImage extends StatelessWidget {
  final String imgURL;
  final double? height;
  final double? width;
  final double? cornerRadius;
  final String errorImage;
  final Color? errorImageColor;
  final Color? backgroundColor;
  final Color? imgColor;
  final BoxFit boxfit;
  final String name;
  final Color? textColor;
  final EdgeInsets letterPadding;

  const CustomImage({
    Key? key,
    this.imgURL = "",
    this.cornerRadius = 0,
    this.height,
    this.width,
    this.boxfit = BoxFit.cover,
    this.errorImage = ImageResources.icPhoto,
    this.errorImageColor = ColorConstants.greyDark,
    this.backgroundColor,
    this.imgColor,
    this.textColor,
    this.name = "",
    this.letterPadding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  Widget defaultImg(BuildContext context) => name.isEmpty
      ? Image.asset(
          errorImage,
          color: errorImageColor,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            errorImage,
            fit: BoxFit.cover,
            color: errorImageColor,
            height: height,
            width: width,
          ),
          fit: boxfit,
          height: height,
          width: width,
        )
      : userName(context);

  Widget userName(BuildContext context) => Padding(
        padding: letterPadding,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            name.toFirstLetter,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor ?? const Color(0xFF808080),
                ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget image = defaultImg(context);
    if (imgURL.isNotEmpty) {
      // Check if Network image...
      if (imgURL.isNetworkImage) {
        image = _cacheImage(context);

        // Check if Asset image...
      } else if (isAssetImage(imgURL)) {
        image = Image.asset(
          imgURL,
          height: height,
          width: width,
          color: imgColor,
          errorBuilder: (context, error, stackTrace) => defaultImg(context),
          fit: boxfit,
        );

        // Check if File image...
      } else if (isFileImage(imgURL)) {
        image = Image.file(
          File(imgURL),
          height: height,
          width: width,
          color: imgColor,
          errorBuilder: (context, error, stackTrace) => defaultImg(context),
          fit: boxfit,
        );
      }
    } else if (name.trim().isNotEmpty) {
      image = userName(context);
    }

    return Container(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: name.trim().isNotEmpty
            ? ColorConstants.greyDark.withOpacity(0.3)
            : backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(cornerRadius ?? 0.0),
        ),
      ),
      height: height,
      width: width,
      child: image,
    );
  }

  Widget _cacheImage(BuildContext context) {
    return CachedNetworkImage(
      fit: boxfit,
      imageUrl: imgURL,
      height: height,
      width: width,
      color: imgColor,
      // placeholder: (context, url) => shimmerWidget(),
      errorWidget: (ctx, url, obj) => defaultImg(context),
    );
  }

  // Widget shimmerWidget() {
  //   return Shimmer.fromColors(
  //     baseColor: ColorConstants.greyDark.withOpacity(0.3),
  //     highlightColor: ColorConstants.grey.withOpacity(0.4),
  //     child: Container(
  //       height: height,
  //       width: width,
  //       color: Colors.white,
  //     ),
  //   );
  // }

  bool isAssetImage(String url) =>
      (url.toLowerCase().contains(ImageResources.assetImageBase) ||
          url.toLowerCase().contains(ImageResources.assetIconBase));

  bool isFileImage(String url) => !isAssetImage(url);
}
