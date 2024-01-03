import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewadiwali/screens/basicWidget/custom_error_widget.dart';
import 'package:sewadiwali/screens/home/widget/grid_box_widget.dart';
import '../../block/home/home_bloc.dart';
import '../../data/sessionManager/session_manager.dart';
import '../../injection_container.dart';
import '../../util/alert/alert_helper.dart';
import '../../util/common_functions.dart';
import '../../util/constants.dart';
import '../../util/string_resources.dart';
import '../basicWidget/loading_widget.dart';
import '../splash_page.dart';
import 'widget/home_user_detail_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  // final _refreshController = RefreshController(initialRefresh: true);

  final loginData = sl<SessionManager>().getUserDetails();
  // Map<String, Widget> options = {
  //   'Upload Food': const Icon(
  //     Icons.food_bank_outlined,
  //     size: 30,
  //     color: Colors.white,
  //   ),
  //   'Upload Photos': const Icon(Icons.photo, size: 40, color: Colors.white),
  //   // 'Photo Upload': const Icon(Icons.photo, size: 40, color: Colors.white),
  //   // 'Change password':
  //   //     const Icon(Icons.password, size: 40, color: Colors.white),
  // };

  List<GridData> options = [];

  final String strChangePassword = 'Change Password';
  final String strDeletAccount = 'Delete Account';
  final String strLogout = 'Logout';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    options = [
      GridData(
        title: "Add Collected Food",
        icon: Icons.food_bank_outlined,
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, addFoodPage);
          if (result == 'refresh') {
            context.read<HomeBloc>().add(const GetHomeDataEvent());
          }
        },
      ),
      GridData(
        title: "Upload Photos",
        icon: Icons.photo,
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, addGalleryPage);
          if (result == 'refresh') {
            context.read<HomeBloc>().add(const GetHomeDataEvent());
          }
        },
      ),
    ];
    callHomeAPI();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is HomeErrorState) {
          sl<CommonFunctions>().showSnackBar(
              context: context,
              message: state.message,
              bgColor: Colors.green,
              textColor: Colors.white);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringResources.appName),
          centerTitle: true,
          actions: [
            SizedBox(
              height: 25,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (String value) async {
                  if (value == strChangePassword) {
                    Navigator.pushNamed(context, changePasswordPage);
                  } else if (value == strDeletAccount) {
                    await Future.delayed(const Duration(milliseconds: 1000));
                    sl<CommonFunctions>().showSnackBar(
                        context: context,
                        message: "Please contact admin to delete your account",
                        bgColor: Colors.green,
                        textColor: Colors.white);
                  } else if (value == strLogout) {
                    AlertHelper.getInstance()!.confirmation(
                      context: context,
                      title: "Are you sure you want to logout?",
                      onPressed: () {
                        sl<SessionManager>().initiateLogout();
                        Navigator.pushNamedAndRemoveUntil(
                            context, splashScreen, (route) => false);
                      },
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: strChangePassword,
                      child: Text(strChangePassword),
                    ),
                    PopupMenuItem<String>(
                      value: strDeletAccount,
                      child: Text(strDeletAccount),
                    ),
                    PopupMenuItem<String>(
                      value: strLogout,
                      child: Text(strLogout),
                    ),
                  ];
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              callHomeAPI();
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return const LoadingWidget();
                } else if (state is HomeSuccessState) {
                  final totalCollectedFood = state.response.totalCollectedFood;
                  final totalThisYearCollectedFood =
                      state.response.collectedFoodThisYear;
                  final totalCenters = state.response.totalCenters;
                  final totalOrganization = state.response.totalOrganizations;
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const HomeUserDetailWidget(),
                          const SizedBox(
                            height: 10,
                          ),
                          loginData != null
                              ? dashboardCount(
                                  title1: "Total Collected Food",
                                  count1: totalCollectedFood,
                                  title2: 'Total Collected Food This Year',
                                  count2: totalThisYearCollectedFood,
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 5,
                          ),
                          loginData != null
                              ? dashboardCount(
                                  title1: 'Total Centers',
                                  count1: totalCenters,
                                  title2: 'Total Organizations',
                                  count2: totalOrganization)
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          GridView.builder(
                            itemCount: options.length,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (ctx, index) =>
                                GridBoxWidget(data: options[index]),

                            // OptionWidget(
                            //   title: options.keys.elementAt(index),
                            //   icon: options[options.keys.elementAt(index)],
                            //   index: index,
                            //   loginData: loginData,
                            // ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CustomErrorWidget(
                    onRetryTap: () {
                      callHomeAPI();
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboardCount({
    String title1 = "",
    String count1 = "",
    String title2 = "",
    String count2 = "",
  }) {
    return Card(
      elevation: 5,
      color: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Set the corner radius to 5
      ), // Set the desired elevation for the Card to add shadow
      child: Container(
        /*decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.white],
          ),
        ),*/
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          count1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          title1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 60, // Width of the vertical line
              color: Colors.white, // Color of the vertical line
            ),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          count2,
                          // '${homeData?.totalCollectedFood ?? "-"} \nFood collection',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          title2,
                          // '${homeData?.totalCollectedFood ?? "-"} \nFood collection',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // void _onRefresh() {
  //   _refreshController.requestLoading();
  //   // context.read<HomeBloc>().add(const FetchHomeData());
  // }

  void callHomeAPI() {
    if (loginData != null) {
      context.read<HomeBloc>().add(const GetHomeDataEvent());
    } else {
      context.read<HomeBloc>().add(const GetStateListEvent());
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
