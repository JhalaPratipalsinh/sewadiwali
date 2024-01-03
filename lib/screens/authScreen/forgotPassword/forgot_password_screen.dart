import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewadiwali/util/custom_image.dart';
import 'package:sewadiwali/util/image_resources.dart';
import 'package:sewadiwali/util/string_extension.dart';

import '../../../block/change_password/change_password_bloc.dart';
import '../../../core/color_constants.dart';
import '../../../injection_container.dart';
import '../../../util/common_functions.dart';
import '../../../util/my_text_field.dart';
import '../../basicWidget/custom_button.dart';
import '../../basicWidget/loading_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordErrorState) {
          showErrorSnackbar(state.message);
        } else if (state is ForgotPasswordSuccessState) {
          sl<CommonFunctions>().showSnackBar(
              context: context,
              message: state.response.message,
              bgColor: Colors.green,
              textColor: Colors.white);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConstants.appColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Forgot Password',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _buildTextWidget(_name, 'Name', TextInputType.name),
                const CustomImage(
                  imgURL: ImageResources.icForgotPassword,
                  height: 100,
                  imgColor: ColorConstants.appColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Please enter you registered email id, and you will get new password on in your register emai id",
                  style: TextStyle(color: ColorConstants.appColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextfield(
                  hint: "Enter email",
                  textEditingController: _email,
                  keyboardtype: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 55,
                  child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                    builder: (context, state) {
                      if (state is ForgotPasswordLoadingState) {
                        return const LoadingWidget();
                      }
                      return ButtonWidget(
                          buttonText: 'Submit',
                          onPressButton: () {
                            if (validation()) {
                              context.read<ChangePasswordBloc>().add(
                                  ForgotPasswordSubmitEvent(
                                      _email.text.trim()));
                            }
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validation() {
    if (_email.text.trim() == "") {
      showErrorSnackbar('Please enter email');
      return false;
    } else if (_email.text.trim().isValidEmail() == false) {
      showErrorSnackbar('Please enter valid email');
      return false;
    }
    return true;
  }

  void showErrorSnackbar(String msg) {
    sl<CommonFunctions>().showSnackBar(
        context: context,
        message: msg,
        bgColor: ColorConstants.red,
        textColor: Colors.white);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    super.dispose();
  }
}
