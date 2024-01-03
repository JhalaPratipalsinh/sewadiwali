import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewadiwali/util/string_extension.dart';
import '../../../../../core/color_constants.dart';
import '../../../../../util/common_functions.dart';
import '../../../block/login/login_bloc.dart';
import '../../../injection_container.dart';
import '../../../util/constants.dart';
import '../../../util/string_resources.dart';
import '../../basicWidget/custom_button.dart';
import '../../basicWidget/loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? emailError;
  String? passswordError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext ctx, state) {
        if (state is LoginErrorState) {
          passswordError = state.error;
          setState(() {});
          // sl<CommonFunctions>().showSnackBar(
          //   context: context,
          //   message: state.error,
          //   bgColor: Colors.red,
          //   textColor: Colors.white,
          // );
        } else if (state is LoadState) {
          // sl<CommonFunctions>().showSnackBar(
          //   context: context,
          //   message: 'Successfully Logged in..',
          //   bgColor: Colors.green,
          //   textColor: Colors.white,
          // );
          Navigator.pushNamedAndRemoveUntil(
              context, homePage, (route) => false);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/loginbg.png'), // Replace with the path to your image
                    fit: BoxFit.cover, // You can adjust this to your needs
                  ),
                ),
                child: Center(child: _buildBody(context))),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ColorConstants.appColor),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext blocContext) {
    ///logo
    final logo = Center(
      child: Container(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
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
            color: ColorConstants.appColor,
          ),
        ),
      ),
    );

    ///Forgot password link
    final forgotPasswordText = InkWell(
      splashColor: Colors.white30,
      onTap: () {
        Navigator.of(context).pushNamed(forgotPasswordPage);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Forgot Password ?',
          style: TextStyle(
              color: ColorConstants.appColor,
              //fontWeight: FontWeight.bold,
              fontSize: 16),
          textAlign: TextAlign.right,
        ),
      ),
    );

    final registerAccountText = InkWell(
      splashColor: Colors.white30,
      onTap: () {
        sl<CommonFunctions>()
            .openAnyUrl("https://sewadiwali.org/RegisterWithUs");
      },
      child: const Text(
        "Don't have an account? Register here",
        style: TextStyle(
            color: ColorConstants.appColor,
            //fontWeight: FontWeight.bold,
            fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            logo,
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "Enter email and password to login.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.normal,
                  fontFamily: fontRegular,
                  color: ColorConstants.textColor1,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildEmailTextWidget(),
            _buildPasswordTextWidget(),
            forgotPasswordText,
            _buildSignInButton(),
            const SizedBox(
              height: 30,
            ),
            registerAccountText,
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTextWidget() {
    return Container(
      // height: 45,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        obscureText: false,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            labelText: "Enter email id.",
            errorText: emailError),
      ),
    );
  }

  Widget _buildPasswordTextWidget() {
    return Container(
        // height: 45,
        margin: const EdgeInsets.all(10),
        child: TextFormField(
          controller: _password,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            labelText: "Enter password",
            errorText: passswordError,
          ),
        ));
  }

  Widget _buildSignInButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoadingState) {
        return const LoadingWidget();
      } else {
        return SizedBox(
          height: 55,
          child: ButtonWidget(
              buttonText: 'Sign In',
              onPressButton: () {
                _validateUser();
                //Navigator.of(context).pushNamed(homePage);
              }),
        );
      }
    });
  }

  Future<void> _validateUser() async {
    emailError = null;
    passswordError = null;
    setState(() {});
    if (_email.text.trim().isEmpty) {
      emailError = "Please enter email";
      setState(() {});
      // sl<CommonFunctions>().showSnackBar(
      //   context: context,
      //   message: 'Please enter email',
      //   bgColor: Colors.orange,
      //   textColor: Colors.white,
      // );
      return;
    } else if (_email.text.trim().isValidEmail() == false) {
      emailError = "Please enter valid email";
      setState(() {});
      // sl<CommonFunctions>().showSnackBar(
      //   context: context,
      //   message: 'Please enter valid email',
      //   bgColor: Colors.orange,
      //   textColor: Colors.white,
      // );
      return;
    } else if (_password.text.trim().isEmpty) {
      passswordError = "Please enter password";
      setState(() {});
      // sl<CommonFunctions>().showSnackBar(
      //   context: context,
      //   message: 'Please enter password',
      //   bgColor: Colors.orange,
      //   textColor: Colors.white,
      // );
      return;
    }

    context.read<LoginBloc>().add(
        InitiateLoginEvent(_email.text.trim(), _password.text.trim(), "fcm"));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
