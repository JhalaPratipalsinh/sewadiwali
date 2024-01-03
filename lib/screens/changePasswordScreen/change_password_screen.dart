import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewadiwali/block/change_password/change_password_bloc.dart';

import '../../core/color_constants.dart';
import '../../data/sessionManager/session_manager.dart';
import '../../injection_container.dart';
import '../../util/common_functions.dart';
import '../../util/my_text_field.dart';
import '../basicWidget/custom_button.dart';
import '../basicWidget/loading_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final loginData = sl<SessionManager>().getUserDetails();

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
        } else if (state is ChangePasswordSuccessState) {
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
            'Change Password',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // _buildTextWidget(_name, 'Name', TextInputType.name),
                    MyTextfield(
                        hint: "Old Password",
                        obscure: true,
                        textEditingController: _oldPassword),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextfield(
                        hint: "New Password",
                        obscure: true,
                        textEditingController: _newPassword),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextfield(
                        hint: "Confirm Password",
                        obscure: true,
                        textEditingController: _confirmPassword),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 55,
                      child:
                          BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                        builder: (context, state) {
                          if (state is ChangePasswordLoadingState) {
                            return const LoadingWidget();
                          }
                          return ButtonWidget(
                              buttonText: 'Submit',
                              onPressButton: () {
                                if (validation()) {
                                  context.read<ChangePasswordBloc>().add(
                                      ChangePasswordSubmitEvent(
                                          (loginData?.id ?? ""),
                                          _oldPassword.text,
                                          _newPassword.text,
                                          _confirmPassword.text));
                                }
                              });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validation() {
    if (_oldPassword.text.trim() == "") {
      showErrorSnackbar('Please enter old password');
      return false;
    } else if (_newPassword.text.trim() == "") {
      showErrorSnackbar('Please enter new password');
      return false;
    } else if (_confirmPassword.text.trim() == "") {
      showErrorSnackbar('Please enter confirm password');
      return false;
    } else if (_newPassword.text.trim() != _confirmPassword.text.trim()) {
      showErrorSnackbar('New password & confirm password not matched');
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
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }
}
