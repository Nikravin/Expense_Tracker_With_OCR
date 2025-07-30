import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/home/bloc/home_bloc/home_screen_bloc.dart';
import 'package:expense_tracker/screens/home/data/data.dart';
import 'package:expense_tracker/screens/home/views/transaction_detail_page.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCard extends StatelessWidget {
  final String currentUser;
  final String category;
  final String id;
  final String amount;
  final String type;
  final Timestamp date;
  final String imgUrl;
  final String note;
  final String dateWord;

  const TransactionCard({
    super.key,
    required this.currentUser,
    required this.category,
    required this.amount,
    required this.id,
    required this.type,
    required this.date,
    required this.dateWord,
    required this.imgUrl,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<UserTransactionDetailBloc>(
                create: (_) => UserTransactionDetailBloc(),
              ),
              BlocProvider<CurrencyBloc>.value(
                value: context.read<CurrencyBloc>(),
              ),
            ],
            child: TransactionDetailPage(
              currentUser: currentUser,
              category: category,
              amount: amount,
              id: id,
              type: type,
              date: date,
              dateWord: dateWord,
              imgUrl: imgUrl,
              note: note,
              // other arguments
            ),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.transactionBoxColor(context),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: type == 'Expense'
                          //     ? Colors.red
                          //     : Colors.green,
                        ),
                      ),
                      type == 'Expense'
                          ? _getExpenseIcon(category, context)
                          : _getIncomeIcon(category, context),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.onBackgroundColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        id,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.outlineColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              BlocBuilder<CurrencyBloc, CurrencyState>(
                builder: (context, currencyState) {
                  String currencySymbol = '\$';
                  if (currencyState is CurrencyLoaded) {
                    currencySymbol = currencyState.currentCurrency.symbol;
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        type == "Expense" ? "-$currencySymbol$amount" : "+$currencySymbol$amount",
                        style: TextStyle(
                          fontSize: 14,
                          color: type == "Expense" ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        dateWord,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.outlineColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
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

  Widget _getIncomeIcon(String categoryName, BuildContext context) {
    for (var ex in myIncomeTransactionData) {
      if (ex['name'] == categoryName) {
        return ex['icon'] as Widget;
      }
    }
    return Icon(Icons.new_label, color: AppTheme.outlineColor(context));
  }
}
