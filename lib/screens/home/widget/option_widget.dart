import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewadiwali/data/model/login_model.dart';
import 'package:sewadiwali/util/constants.dart';

import '../../../block/home/home_bloc.dart';

class OptionWidget extends StatelessWidget {
  final String title;
  final Widget? icon;
  final int index;
  final LoginData? loginData;

  const OptionWidget(
      {required this.title,
      required this.icon,
      required this.index,
      this.loginData,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (title == 'Upload Photos') {
          final result = await Navigator.pushNamed(context, addGalleryPage);
          if (result == 'refresh') {
            if (loginData != null) {
              context.read<HomeBloc>().add(const GetHomeDataEvent());
            } else {
              context.read<HomeBloc>().add(const GetStateListEvent());
            }
          }
          // Navigator.pushNamed(context, addGalleryPage);
        } else if (loginData == null) {
          // Navigator.pushNamedAndRemoveUntil(
          //     context, splashScreen, (route) => false);
          Navigator.pop(context);
        } else if (title == 'Upload Food') {
          final result = await Navigator.pushNamed(context, addFoodPage);
          if (result == 'refresh') {
            if (loginData != null) {
              context.read<HomeBloc>().add(const GetHomeDataEvent());
            } else {
              context.read<HomeBloc>().add(const GetStateListEvent());
            }
          }
        } else if (title == 'Photo Upload') {
          // Navigator.pushNamed(context, changePasswordPage);
        } else if (title == 'Change password') {
          Navigator.pushNamed(context, changePasswordPage);
          
        } else if (index == 4) {
          //Navigator.pushNamed(context, trainingReportPage);
        } else {
          //Navigator.pushNamed(context, addBatchPlaningPage);
        }
      },
      child: Card(
        elevation: 3,
        color: _getColor(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*const SizedBox(
                height: 20,
              ),*/
              icon ?? const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              /*const SizedBox(
                height: 20,
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    if (title == 'Upload Food') {
      return Colors.deepPurple;
    } else if (title == 'Upload Photos') {
      return Colors.deepOrange;
    } else if (title == 'Photo Upload') {
      return Colors.cyan;
    } else if (title == 'Change password') {
      return Colors.teal;
    } else if (index == 4) {
      return Colors.lightBlueAccent;
    } else {
      return Colors.brown;
    }
  }
}
