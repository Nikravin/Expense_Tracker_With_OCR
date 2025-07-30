// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/home/bloc/home_bloc/home_screen_bloc.dart';
import 'package:expense_tracker/screens/home/data/data.dart';
import 'package:expense_tracker/screens/home/views/home_screen.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:expense_tracker/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatelessWidget {
  final String currentUser;
  final String category;
  final String id;
  final String amount;
  final String type;
  final Timestamp date;
  final String imgUrl;
  final String note;
  final String dateWord;
  const TransactionDetailPage({
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
    DateTime formatedDate = date.toDate();

    return Scaffold(
      appBar: Appbar(title: "Transaction Details"),
      backgroundColor: AppTheme.backgroundColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<UserTransactionDetailBloc, UserTransactionState>(
            listener: (context, state) {
              if (state is UserTransactionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.green,
                      ),
                      child: const Text(
                        "Transaction deleted successfully",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    margin: const EdgeInsets.all(16),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else if (state is UserTransactionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red,
                      ),
                      child: const Text(
                        "Error deleting transaction",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    margin: const EdgeInsets.all(16),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(context),
                        const SizedBox(height: 24),

                        _buildCategoryHeader(context),
                        const SizedBox(height: 24),

                        _buildAmountCard(context),
                        const SizedBox(height: 20),

                        _buildTransactionDetailsCard(context, formatedDate),
                        const SizedBox(height: 20),

                        _buildNotesSection(context),
                        const SizedBox(height: 32),

                        _buildDeleteButton(context),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imgUrl.isNotEmpty
            ? Stack(
                children: [
                  Image.network(
                    imgUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildNoImagePlaceholder();
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : _buildNoImagePlaceholder(),
      ),
    );
  }

  Widget _buildNoImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[100]!, Colors.grey[200]!],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              "No Image",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (type == 'Expense' ? Colors.red : Colors.green)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: type == 'Expense'
                    ? _getExpenseIcon(category, context)
                    : _getIncomeIcon(category, context),
              ),
              const SizedBox(width: 12),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context) {
    final isExpense = type == "Expense";
    final amountColor = isExpense ? Colors.red : Colors.green;

    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        String currencySymbol = '\$';
        if (currencyState is CurrencyLoaded) {
          currencySymbol = currencyState.currentCurrency.symbol;
        }
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [amountColor.withOpacity(0.1), amountColor.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: amountColor.withOpacity(0.2), width: 1),
          ),
          child: Column(
            children: [
              Text(
                type,
                style: TextStyle(
                  color: amountColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${isExpense ? "-" : "+"}$currencySymbol$amount",
                style: TextStyle(
                  color: amountColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionDetailsCard(
    BuildContext context,
    DateTime formatedDate,
  ) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaction Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow("ID", id, Icons.tag),
            const SizedBox(height: 12),
            _buildDetailRow(
              "Date",
              DateFormat('MMM dd, yyyy').format(formatedDate),
              Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              "Time",
              DateFormat('hh:mm a').format(formatedDate),
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note_outlined, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Text(
                note.isEmpty ? "No notes available" : note,
                style: TextStyle(
                  fontSize: 15,
                  color: note.isEmpty ? Colors.grey[500] : Colors.black87,
                  fontStyle: note.isEmpty ? FontStyle.italic : FontStyle.normal,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => _showDeleteConfirmationDialog(context),
        icon: const Icon(Icons.delete_outline, size: 20),
        label: const Text(
          "Delete Transaction",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_outlined,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Delete Transaction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete this transaction? This action cannot be undone.",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              context.read<UserTransactionDetailBloc>().add(
                UserTransactionDetailsEvent(
                  transactionId: id,
                  userId: currentUser,
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              "Delete",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
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
