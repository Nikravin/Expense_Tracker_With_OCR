import 'dart:math';
import 'package:expense_tracker/model/user_fetch_data.dart';
import 'package:expense_tracker/model/user_local_data_model.dart';
import 'package:expense_tracker/screens/add_expense/bloc/add_expense_bloc.dart';
import 'package:expense_tracker/screens/add_expense/views/add_expense.dart';
import 'package:expense_tracker/screens/dashboard/screens/dashboard_screen.dart';
import 'package:expense_tracker/screens/home/bloc/home_bloc/home_screen_bloc.dart';
import 'package:expense_tracker/screens/home/bloc/quick_expense_or_income_bloc/quick_expense_or_income_bloc.dart';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:expense_tracker/screens/profile/bloc/app_theme/app_theme_bloc.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late UserLocalData? userId;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    userId = getUserLocalData();
    _pages = [
      MultiBlocProvider(
    providers: [
      // Home Screen User Detail Bloc
      BlocProvider<HomeScreenUserDetailBloc>(
        create: (context) => HomeScreenUserDetailBloc()
          ..add(
            UserDetailsEvent(),
          ),
      ),
      
      // Quick Expense Or Income Bloc
      BlocProvider<QuickExpenseOrIncomeBloc>(
        create: (context) => QuickExpenseOrIncomeBloc(),
      ),
      
      // Add Expense Bloc - This fixes your original error!
      BlocProvider<AddExpenseBloc>(
        create: (context) => AddExpenseBloc(userId!.id.toString()),
      ),
      
      // User Search Transaction Bloc
      BlocProvider<UserSearchTransactionBloc>(
        create: (context) => UserSearchTransactionBloc(),
      ),
      
      BlocProvider<AppThemeBloc>(
        create: (context) => AppThemeBloc(),
      ),
      
    ],
    child: MainScreen(currentUser: userId!.id.toString()),
  ), 
  DashboardScreen(),
  ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor(context),
              AppTheme.secondaryColor(context),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          child: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            backgroundColor: Colors.transparent,
            showSelectedLabels: false,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor(context),
        shape: CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor(context),
                AppTheme.secondaryColor(context),
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: Icon(
            CupertinoIcons.add,
            color: AppTheme.bottomNavigationBarAddBigButtonColor(context),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => AddExpenseBloc(userId!.id.toString()),
                child: AddExpense(userId: userId!.id.toString()),
              ),
            ),
          );
        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}
