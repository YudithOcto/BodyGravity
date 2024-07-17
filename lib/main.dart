import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/di/di_container.dart';
import 'package:bodygravity/ui/auth/bloc/login_bloc.dart';
import 'package:bodygravity/ui/chart/bloc/chart_bloc.dart';
import 'package:bodygravity/ui/customer/bloc/customer_bloc.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_bloc.dart';
import 'package:bodygravity/ui/splash/splash_screen.dart';
import 'package:bodygravity/ui/transactions/add_session/bloc/add_session_bloc.dart';
import 'package:bodygravity/ui/transactions/bloc/transaction_bloc.dart';
import 'package:bodygravity/ui/transactions/end_session/bloc/end_session_bloc.dart';
import 'package:bodygravity/ui/transactions/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(create: (context) => locator<LoginBloc>()),
          BlocProvider<DashboardBloc>(
              create: (context) => locator<DashboardBloc>()),
          BlocProvider<CustomerBloc>(
              create: (context) => locator<CustomerBloc>()),
          BlocProvider<TransactionBloc>(
              create: (context) => locator<TransactionBloc>()),
          BlocProvider<SearchBloc>(create: (context) => locator<SearchBloc>()),
          BlocProvider<AddSessionBloc>(
              create: (context) => locator<AddSessionBloc>()),
          BlocProvider<EndSessionBloc>(create: (context) => locator<EndSessionBloc>()),
          BlocProvider<Chartbloc>(create: (context) => locator<Chartbloc>()),
        ],
        child: MaterialApp(
          title: 'Body Gravity',
          navigatorKey: navigatorKey,
          theme: ThemeData(
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scrollbarTheme: ScrollbarThemeData(
              trackVisibility: MaterialStateProperty.all(true),
              thumbVisibility: MaterialStateProperty.all(true)
            ),
            primarySwatch: Colors.deepPurple,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            colorScheme: const ColorScheme.light(primary: AppColors.yellow500, ),
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ));
  }
}
