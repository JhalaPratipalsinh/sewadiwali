import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/color_constants.dart';

class MyTextfield extends StatelessWidget {
  final String hint;
  final Color hintColor;
  final double hintFontSize;
  final double height;
  final double width;
  final FormFieldValidator<String>? validator;
  final TextEditingController textEditingController;
  final TextInputType keyboardtype;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscure;
  final bool readonly;
  final bool showicon;
  final bool showLabelText;
  final TextAlign textAlign;
  final int? maxlenght;
  final int? maxLine;
  final Function()? ontap;
  final Function(String)? onSaved;
  final Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  const MyTextfield({
    Key? key,
    required this.hint,
    this.hintFontSize = 18,
    this.validator,
    required this.textEditingController,
    this.hintColor = ColorConstants.greyDark,
    this.obscure = false,
    this.readonly = false,
    this.showicon = true,
    this.showLabelText = true,
    this.textAlign = TextAlign.left,
    this.ontap,
    this.keyboardtype = TextInputType.text,
    this.inputFormatters,
    this.maxlenght,
    this.maxLine = 1,
    this.onSaved,
    this.onChanged,
    this.height = 50,
    this.width = double.infinity,
    this.autovalidateMode,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        // boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]
      ),
      child: TextFormField(
        textCapitalization: TextCapitalization.none,
        maxLines: maxLine,
        maxLength: maxlenght,
        readOnly: readonly,
        focusNode: focusNode,
        obscureText: obscure,
        keyboardType: keyboardtype,
        inputFormatters: inputFormatters,
        onTap: readonly ? ontap : null,
        controller: textEditingController,
        onSaved: ((newValue) {
          onSaved!(newValue!);
        }),
        autovalidateMode: autovalidateMode,
        textAlign: textAlign,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            counterText: "",
            hintText: hint,
            labelText: showLabelText ? hint : "",
            labelStyle: TextStyle(color: hintColor),
            border: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorConstants.colorPrimaryDark, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            // focusColor: ColorConstants.colorPrimaryDark,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorConstants.colorPrimaryDark, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
            hintStyle: TextStyle(color: hintColor)
            // hintStyle: Theme.of(context)
            //     .textTheme
            //     .displayLarge
            //     ?.copyWith(fontSize: hintFontSize, color: hintColor),
            ),
        validator: validator,
      ),
    );
  }
}
