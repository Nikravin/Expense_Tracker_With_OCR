import 'package:expense_tracker/model/user_local_data_model.dart';
import 'package:expense_tracker/screens/profile/bloc/app_theme/app_theme_bloc.dart';
import 'package:expense_tracker/screens/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:expense_tracker/screens/splash_screen/views/splash_screen.dart';
import 'package:expense_tracker/services/currency_service.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(UserLocalDataAdapter());
  Hive.registerAdapter(UserBalanceLocalDataAdapter());
  Hive.registerAdapter(CurrencyLocalDataAdapter());
  await Hive.openBox<UserLocalData>('userBox');
  await Hive.openBox<UserBalanceLocalData>('userBalanceBox');
  await Hive.openBox<CurrencyLocalData>('currencyBox');

  // Initialize currency service
  await CurrencyService.initialize();

  runApp(
    BlocProvider(create: (context) => AppThemeBloc(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrencyBloc()..add(LoadCurrency()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Expense Tracker",
        home: BlocProvider(
          create: (context) => SplashScreenBloc(),
          child: SplashScreen(),
        ),
      ),
    );
  }
}
