import 'package:expense_tracker/screens/dashboard/bloc/main_dashboard/dashboard_bloc.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';
import '../models/expense_data.dart';
import '../widgets/overview_cards.dart';
import '../widgets/spending_trends_chart.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/category_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc()..add(DashboardCurrentMonth()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor(context),
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor(context),
          elevation: 0,
          title: const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              String? currentExpense;
              bool isLoading = state is DashboradLoading;
              if (state is DashboardCurrentMonthExpenseLoaded) {
                currentExpense = state.currentMonthExpense;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Section
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const OverviewCards(),

                  const SizedBox(height: 24),

                  // Spending Trends Section
                  const Text(
                    'Spending Trends',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monthly Spending',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  BlocBuilder<CurrencyBloc, CurrencyState>(
                    builder: (context, currencyState) {
                      String currencySymbol = '₹';
                      if (currencyState is CurrencyLoaded) {
                        currencySymbol = currencyState.currentCurrency.symbol;
                      }
                      
                      return Text(
                        '$currencySymbol$currentExpense',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ).redacted(
                        context: context,
                        redact: isLoading,
                        configuration: RedactedConfiguration(
                          redactedColor: Colors.grey[60],
                          defaultBorderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                  ),
                  Text(
                    'Last 6 Months -5%',
                    style: TextStyle(fontSize: 12, color: Colors.red[400]),
                  ),
                  const SizedBox(height: 16),
                  const SpendingTrendsChart(),

                  const SizedBox(height: 30),

                  // Category Breakdown Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category Breakdown',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Spending by Category',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          BlocBuilder<CurrencyBloc, CurrencyState>(
                            builder: (context, currencyState) {
                              String currencySymbol = '₹';
                              if (currencyState is CurrencyLoaded) {
                                currencySymbol = currencyState.currentCurrency.symbol;
                              }
                              
                              return Text(
                                '$currencySymbol${DashboardData.totalExpenses.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          Text(
                            'This Month -3%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                      const CategoryPieChart(),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: const CategoryList(),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
