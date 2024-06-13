import 'package:bodygravity/data/auth/auth_repository.dart';
import 'package:bodygravity/data/customer/customer_repository.dart';
import 'package:bodygravity/data/local/storage_service.dart';
import 'package:bodygravity/services/dio_services.dart';
import 'package:bodygravity/data/network/network_services.dart';
import 'package:bodygravity/services/hive_storage_services.dart';
import 'package:bodygravity/ui/auth/bloc/login_bloc.dart';
import 'package:bodygravity/ui/customer/bloc/customer_bloc.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register Dio
  final options = BaseOptions(
      baseUrl: "http://103.189.234.159:7000",
      receiveTimeout: const Duration(milliseconds: 5000),
      maxRedirects: 3,
      connectTimeout: const Duration(milliseconds: 5000));

  final dio = Dio(options);
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    request: true,
    error: true,
  ));
  dio.transformer = BackgroundTransformer();
  dio.options.contentType = Headers.formUrlEncodedContentType;

  // Register Third Party
  locator.registerSingleton<Dio>(dio);
  final storageServices = HiveStorageService();
  await storageServices.init();
  locator.registerLazySingleton<StorageService>(() => storageServices);

  // Register NetworkService
  locator.registerSingleton<NetworkService>(
      DioService(locator<Dio>(), locator<StorageService>()));

  // Register Repository
  locator.registerSingleton<AuthRepository>(DefaultAuthRepository(
      locator<NetworkService>(), locator<StorageService>()));
  locator.registerSingleton<CustomerRepository>(
      DefaultCustomerRepository(locator<NetworkService>()));

  // Register Bloc
  locator.registerSingleton<LoginBloc>(LoginBloc(locator<AuthRepository>()));
  locator.registerSingleton<DashboardBloc>(
      DashboardBloc(locator<AuthRepository>()));
  locator.registerSingleton<CustomerBloc>(
      CustomerBloc(locator<CustomerRepository>()));
}
