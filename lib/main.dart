import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'block/add_food_collection/add_food_collection_bloc.dart';
import 'block/add_gallery/add_gallery_bloc.dart';
import 'block/change_password/change_password_bloc.dart';
import 'block/home/home_bloc.dart';
import 'block/login/login_bloc.dart';
import 'core/color_constants.dart';
import 'core/global_nav_key.dart';
import 'core/route_generator.dart';
import 'injection_container.dart' as di;
import 'util/constants.dart';
import 'util/string_resources.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => di.sl<LoginBloc>()),
        BlocProvider<HomeBloc>(create: (_) => di.sl<HomeBloc>()),
        BlocProvider<AddGalleryBloc>(create: (_) => di.sl<AddGalleryBloc>()),
        BlocProvider<ChangePasswordBloc>(create: (_) => di.sl<ChangePasswordBloc>()),
        BlocProvider<AddFoodCollectionBloc>(
            create: (_) => di.sl<AddFoodCollectionBloc>()),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: StringResources.appName,
            navigatorKey: GlobalNavKey.navState,
            theme: ThemeData(
              useMaterial3: false,
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
              //fontFamily: 'Montserrat',
              primaryColor: ColorConstants.appColor,
              primarySwatch: createMaterialColor(ColorConstants.appColor),
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.grey[500],
              unselectedWidgetColor: Colors.black45,
              focusColor: Colors.grey.shade50,
              cardTheme: const CardTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: splashScreen,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }),
      ),
    );
  }
}
