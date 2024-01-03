import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sewadiwali/block/add_food_collection/add_food_collection_bloc.dart';
import 'package:sewadiwali/block/change_password/change_password_bloc.dart';
import 'package:sewadiwali/data/repositoryImpl/add_food_collection_repository_impl.dart';
import 'package:sewadiwali/domain/add_food_collection_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'block/add_gallery/add_gallery_bloc.dart';
import 'block/home/home_bloc.dart';
import 'block/login/login_bloc.dart';
import 'data/apiService/base_api_service.dart';
import 'data/apiService/network_api_service.dart';
import 'data/repositoryImpl/add_gallery_repository_impl.dart';
import 'data/repositoryImpl/change_password_reposiroty_impl.dart';
import 'data/repositoryImpl/home_repository_impl.dart';
import 'data/repositoryImpl/login_repository_impl.dart';
import 'data/sessionManager/session_manager.dart';
import 'domain/add_gallery_repository.dart';
import 'domain/change_password_repository.dart';
import 'domain/home_repository.dart';
import 'domain/login_repository.dart';
import 'util/common_functions.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External /* All the other required external injection are embedded here */
  await _initExternalDependencies();

  // Repository /* All the repository injection are embedded here */
  _initRepositories();

  // Bloc /* All the bloc injection are embedded here */
  _initBlocs();

  // Cubit /* All the cubit injection are embedded here */
  _initCubit();
}

void _initBlocs() {
  //Add Login Bloc
  sl.registerFactory(
    () => LoginBloc(
      repository: sl(),
    ),
  );

  //Add Home Bloc
  sl.registerFactory(
    () => HomeBloc(
      repository: sl(),
    ),
  );

  //Add Add Food Collection Bloc
  sl.registerFactory(
    () => AddFoodCollectionBloc(
      repository: sl(),
    ),
  );

  //Add Add Gallery Bloc
  sl.registerFactory(
    () => AddGalleryBloc(
      repository: sl(),
    ),
  );

  //Add Add Gallery Bloc
  sl.registerFactory(
    () => ChangePasswordBloc(
      repository: sl(),
    ),
  );
}

void _initCubit() {
  //Add PageIndicator cubit

  /*sl.registerFactory(
    () => AttendanceDateCubit(),
  );*/
}

void _initRepositories() {
  //Api Service
  sl.registerLazySingleton<BaseAPIService>(
    () => NetworkAPIService(dio: sl(), connectivity: sl()),
  );

  //Login  Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(baseAPIService: sl(), sessionManager: sl()),
  );

  //Home  Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      baseAPIService: sl(),
    ),
  );

  //Add Food Collection  Repository
  sl.registerLazySingleton<AddFoodCollectionRepository>(
    () => AddFoodCollectionRepositoryImpl(
      baseAPIService: sl(),
    ),
  );

  //Add Gallery  Repository
  sl.registerLazySingleton<AddGalleryRepository>(
    () => AddGalleryRepositoryImpl(
      baseAPIService: sl(),
    ),
  );

  //Add Gallery  Repository
  sl.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(
      baseAPIService: sl(),
    ),
  );
}

Future<void> _initExternalDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => SessionManager(sl()));
  sl.registerLazySingleton(() => const CommonFunctions());
  sl.registerLazySingleton(() => Connectivity());

  final dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
  sl.registerLazySingleton(() => dio);
}
