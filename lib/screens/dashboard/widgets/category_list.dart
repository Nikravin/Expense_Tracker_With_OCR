import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_bloc.dart';
import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_event.dart';
import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_state.dart';
import 'package:expense_tracker/screens/home/data/data.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
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

    return BlocProvider(
      create: (context) => CategoryListBloc()..add(CategoryShowEvent()),
      child: BlocBuilder<CategoryListBloc, CategoryListState>(
        builder: (context, state) {
          bool isLoading = state is CategoryListLoadingState;
          
          if (state is CategoryListErrorState) {
            return SizedBox(
              width: double.infinity,
              height: 500,
              child: Center(child: Text("Some Error Occured.")),
            );
          }
          if (state is CategoryListLoadedState) {
            final categories = state.categoryList;
            int lineLength = int.parse(state.lineLength);

            return Column(
              children: categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final color = colors[index % colors.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Category Icon and Color Indicator
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: _getExpenseIcon(category.name, context),
                        ),
                      ).redacted(context: context, redact: isLoading,  configuration: RedactedConfiguration(
              redactedColor: Colors.grey[600],
              defaultBorderRadius: BorderRadius.circular(10),
            ),),
                      const SizedBox(width: 16),
                      // Category Name and Progress Bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                                      '$currencySymbol${category.amount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Progress Bar
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor:
                                    category.amount /
                                    lineLength, // Max value for scaling
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
          // Show loading state with placeholder items
          return Column(
            children: List.generate(5, (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  // Category Icon placeholder
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).redacted(
                    context: context,
                    redact: isLoading,
                    configuration: RedactedConfiguration(
                      redactedColor: Colors.grey[60],
                      defaultBorderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Category details placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 120,
                              height: 16,
                              color: Colors.grey[300],
                            ).redacted(
                              context: context,
                              redact: isLoading,
                              configuration: RedactedConfiguration(
                                redactedColor: Colors.grey[60],
                                defaultBorderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 16,
                              color: Colors.grey[300],
                            ).redacted(
                              context: context,
                              redact: isLoading,
                              configuration: RedactedConfiguration(
                                redactedColor: Colors.grey[60],
                                defaultBorderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progress Bar placeholder
                        Container(
                          height: 6,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ).redacted(
                          context: context,
                          redact: isLoading,
                          configuration: RedactedConfiguration(
                            redactedColor: Colors.grey[60],
                            defaultBorderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }

  Widget _getExpenseIcon(String categoryName, BuildContext context) {
    for (var ex in myExpenseTransactionData) {
      if (ex['name'] == categoryName) {
        return ex['icon'] as Widget;
      }
    }
    return Icon(Icons.new_label, color: AppTheme.outlineColor(context));
  }
}
