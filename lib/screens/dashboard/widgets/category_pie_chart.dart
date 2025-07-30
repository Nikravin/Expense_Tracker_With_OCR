import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_bloc.dart';
import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_event.dart';
import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_state.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';
import '../models/expense_data.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryListBloc()..add(CategoryShowEvent()),
      child: BlocBuilder<CategoryListBloc, CategoryListState>(
        builder: (context, state) {
          bool isLoading = state is CategoryListLoadingState;
          if (state is CategoryListLoadedState) {
            final categories = state.categoryList;
            return BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, currencyState) {
                String currencySymbol = '₹';
                if (currencyState is CurrencyLoaded) {
                  currencySymbol = currencyState.currentCurrency.symbol;
                }
                
                return SizedBox(
                  width: 120,
                  height: 120,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: _generateSections(categories, currencySymbol),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle touch events if needed
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: Colors.grey[60]),
          ).redacted(
            context: context,
            redact: isLoading,
            configuration: RedactedConfiguration(
              redactedColor: Colors.grey[60],
              defaultBorderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _generateSections(
    List<ExpenseCategory> categories,
    String currencySymbol,
  ) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    final total = categories.fold(
      0.0,
      (sum, category) => sum + category.amount,
    );

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final percentage = (category.amount / total * 100);

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: category.amount,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 35,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
