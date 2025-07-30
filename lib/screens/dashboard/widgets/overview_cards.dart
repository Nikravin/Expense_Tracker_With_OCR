import 'package:expense_tracker/model/user_fetch_data.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = getUserBalanceLocalData();
    String income = userInfo!.userIncomeAmount!.toStringAsFixed(0);
    String expense = userInfo.userExpenseAmount!.toStringAsFixed(0);

    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        String currencySymbol = '₹';
        if (currencyState is CurrencyLoaded) {
          currencySymbol = currencyState.currentCurrency.symbol;
        }
        
        return Row(
          children: [
            Expanded(
              child: _buildCard(
                'Income',
                '$currencySymbol$income',
                '+10%',
                Colors.green,
                Colors.green[50]!,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                'Expenses',
                '$currencySymbol$expense',
                '-5%',
                Colors.red,
                Colors.red[50]!,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(
    String title,
    String amount,
    String percentage,
    Color color,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
