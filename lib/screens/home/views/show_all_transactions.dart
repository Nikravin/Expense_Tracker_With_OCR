import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/home/bloc/home_bloc/home_screen_bloc.dart';
import 'package:expense_tracker/screens/home/widget/transaction_card.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:expense_tracker/utils/date_formate_word.dart';
import 'package:expense_tracker/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ShowAllTransactions extends StatefulWidget {
  final String userId;
  const ShowAllTransactions({super.key, required this.userId});

  @override
  State<ShowAllTransactions> createState() => _ShowAllTransactionsState();
}

class _ShowAllTransactionsState extends State<ShowAllTransactions> {
  String? dateInWord;
  String? _mainFilterType = "All";
  String? searchText = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserSearchTransactionBloc>().add(
      UserFilterTransactionEvent(
        filterType: _mainFilterType!,
        userId: widget.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: "All Transactions"),
      backgroundColor: AppTheme.backgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterSection(context),

            // Content Section
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Transactions Header
                    _buildTransactionsHeader(context),
                    const SizedBox(height: 16),

                    // Transactions List
                    Expanded(
                      child:
                          BlocBuilder<
                            UserSearchTransactionBloc,
                            UserSearchTransactionState
                          >(
                            builder: (context, state) {
                              if (state is UserSearchTransactionLoading) {
                                return _buildLoadingState();
                              } else if (state is UserSearchTransactionError) {
                                return _buildErrorState();
                              } else if (state
                                  is UserSearchTransactionSuccess) {
                                final transactions = state.transactions;
                                _mainFilterType = state.filterType;

                                if (transactions.isEmpty) {
                                  return _buildEmptyState();
                                }

                                final filteredTransactions =
                                    _getFilteredTransactions(transactions);

                                if (filteredTransactions.isEmpty &&
                                    searchText!.isNotEmpty) {
                                  return _buildNoSearchResultsState();
                                }

                                return _buildTransactionsList(
                                  filteredTransactions,
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFilterSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Filter Dropdown
          Expanded(flex: 2, child: _buildFilterDropdown()),
          const SizedBox(width: 8),
          // Search Field
          Expanded(flex: 3, child: _buildSearchField()),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    final List<String> mainFilter = ["All", "Expense", "Income"];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          prefixIcon: Icon(Icons.filter_list, size: 20),
        ),
        value: _mainFilterType,
        items: mainFilter.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(
              type,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: (value) {
          context.read<UserSearchTransactionBloc>().add(
            UserFilterTransactionEvent(
              filterType: value.toString(),
              userId: widget.userId,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintText: "Search transactions...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: searchText!.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchText = "";
                    });
                  },
                  icon: Icon(Icons.clear, size: 20, color: Colors.grey[600]),
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            searchText = value.trim().toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            "Recent Transactions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          if (searchText!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Searching...",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 16),
          Text(
            "Loading transactions...",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.error_outline, color: Colors.red, size: 48),
          ),
          const SizedBox(height: 16),
          const Text(
            "Something went wrong",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Unable to load transactions. Please try again.",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: Colors.grey[400],
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No transactions found",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Start adding transactions to see them here",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.search_off, color: Colors.orange[400], size: 64),
          ),
          const SizedBox(height: 24),
          const Text(
            "No results found",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'No transactions match "$searchText"',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<dynamic> transactions) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final ds = transactions[index];
        DateTime? date;

        if (ds["date"] is Timestamp) {
          date = (ds["date"] as Timestamp).toDate();
        } else if (ds["date"] is String) {
          date = DateFormat('dd MM yyyy').parse(ds["date"]);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: TransactionCard(
            currentUser: widget.userId,
            category: ds["category"],
            amount: ds["amount"].toString(),
            id: ds["trancationId"],
            type: ds["type"],
            date: ds["date"],
            dateWord: formatFriendlyDate(date!),
            imgUrl: ds["imageUrl"],
            note: ds["note"],
          ),
        );
      },
    );
  }

  List<dynamic> _getFilteredTransactions(List<dynamic> transactions) {
    if (searchText == null || searchText!.isEmpty) {
      return transactions;
    }

    final search = searchText!.toLowerCase();
    return transactions.where((ds) {
      final category = ds["category"].toString().toLowerCase();
      final amount = ds["amount"].toString().toLowerCase();
      final transactionId = ds["trancationId"].toString().toLowerCase();

      return category.contains(search) ||
          amount.contains(search) ||
          transactionId.contains(search);
    }).toList();
  }

  Container filterTranactions(BuildContext context) {
    List<String> mainFilter = ["All", "Expense", "Income"];

    return Container(
      width: double.infinity,
      height: 70,
      // color: Colors.amber,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: DropdownButtonFormField(
              padding: EdgeInsets.symmetric(vertical: 3),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(icon, color: Colors.black26),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: _mainFilterType,
              items: mainFilter.map((type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                context.read<UserSearchTransactionBloc>().add(
                  UserFilterTransactionEvent(
                    filterType: value.toString(),
                    userId: widget.userId,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                suffixIcon: searchText!.isEmpty
                    ? Icon(Icons.search, color: Colors.black26)
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchText = "";
                          });
                        },
                        icon: Icon(Icons.cancel),
                      ),
                filled: true,
                fillColor: Colors.white,
                hint: Text(
                  "search",
                  style: TextStyle(color: Colors.black26, fontSize: 20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim().toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
