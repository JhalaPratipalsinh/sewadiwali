import 'package:flutter/material.dart';

import '../../core/color_constants.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;

  const LoadingWidget({this.color = ColorConstants.appColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ),
    );
  }
}
