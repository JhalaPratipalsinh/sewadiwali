import 'package:flutter/material.dart';
import '../../core/color_constants.dart';
import '../../util/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final Function onPressButton;
  final bool isWrap;
  final bool isBorder;
  final double padding;
  final double fontSize;
  final double buttonRadius;
  final Color clr;

  const ButtonWidget({
    required this.buttonText,
    required this.onPressButton,
    this.clr = ColorConstants.colorPrimary,
    this.isWrap = false,
    this.isBorder = false,
    this.padding = 5,
    this.fontSize = 14,
    this.buttonRadius = 5,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ElevatedButton(
        style: isWrap
            ? ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: isBorder ? Colors.white : clr,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
                side: BorderSide(
                    width: isBorder ? 1.5 : 0,
                    color: ColorConstants.appColor,
                    style: BorderStyle.solid),
              )
            : ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                onPrimary: Colors.white,
                primary: isBorder ? Colors.white : clr,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
                side: BorderSide(
                    width: isBorder ? 1.5 : 0,
                    color: ColorConstants.appColor,
                    style: BorderStyle.solid),
              ),
        onPressed: () => onPressButton(),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            buttonText,
            style: TextStyle(
              color: isBorder ? ColorConstants.textColor1 : Colors.white,
              fontSize: fontSize,
              fontFamily: fontRegular,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
