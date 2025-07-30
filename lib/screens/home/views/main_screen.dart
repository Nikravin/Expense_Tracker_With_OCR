// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/user_fetch_data.dart';
import 'package:expense_tracker/screens/add_expense/model/add_trancation_model.dart';
import 'package:expense_tracker/screens/home/bloc/home_bloc/home_screen_bloc.dart';
import 'package:expense_tracker/screens/home/bloc/quick_expense_or_income_bloc/quick_expense_or_income_bloc.dart';
import 'package:expense_tracker/screens/home/bloc/quick_expense_or_income_bloc/quick_expense_or_income_event.dart';
import 'package:expense_tracker/screens/home/bloc/quick_expense_or_income_bloc/quick_expense_or_income_state.dart';
import 'package:expense_tracker/screens/home/repository/home_screen_repo.dart';
import 'package:expense_tracker/screens/home/views/show_all_transactions.dart';
import 'package:expense_tracker/screens/home/views/quick_scan_screen.dart';
import 'package:expense_tracker/screens/home/widget/transaction_card.dart';
import 'package:expense_tracker/screens/add_expense/bloc/add_expense_bloc.dart';
import 'package:expense_tracker/screens/profile/views/profile_page.dart';
import 'package:expense_tracker/services/currency/currency_bloc.dart';
import 'package:expense_tracker/utils/constants.dart';
import 'package:expense_tracker/utils/date_formate_word.dart';
import 'package:expense_tracker/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:redacted/redacted.dart';

class MainScreen extends StatefulWidget {
  final String currentUser;
  const MainScreen({super.key, required this.currentUser});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final Stream<QuerySnapshot> userTrancations;
  final TextEditingController _amountController = TextEditingController();
  String? userLocalName;
  String? dropDownCategory;

  @override
  void initState() {
    super.initState();
    context.read<HomeScreenUserDetailBloc>().add(UserDetailsEvent());
    userTrancations = HomeScreenRepo().getUserLimitedTrancationsDetails(
      widget.currentUser,
    );
    final userInfo = getUserLocalData();
    userLocalName = userInfo!.name!.capitalizeFirst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // Listen for successful transactions and refresh balance
            BlocListener<AddExpenseBloc, AddExpenseState>(
              listener: (context, state) {
                if (state is AddTransactionSuccess) {
                  // Automatically refresh balance when transaction is successful
                  context.read<HomeScreenUserDetailBloc>().add(
                    UserDetailsEvent(),
                  );
                  _showSuccessSnackBar("Transaction added successfully!");
                }
                if (state is AddTransactionError) {
                  _showErrorSnackBar(
                    "Failed to add transaction: ${state.message}",
                  );
                }
              },
            ),
            // Optional: Listen for balance updates
            BlocListener<HomeScreenUserDetailBloc, HomeScreenState>(
              listener: (context, state) {
                if (state is HomeScreenSuccess) {
                  // Balance has been updated successfully
                  // Debug: Balance updated - Total: ${state.userTotalBalance}
                }
              },
            ),
            // Listen for currency changes to update the UI
            BlocListener<CurrencyBloc, CurrencyState>(
              listener: (context, state) {
                if (state is CurrencyLoaded) {
                  // Currency has been updated, no need to refresh balance
                  // The BlocBuilder will automatically rebuild with new currency symbol
                  // Debug: Currency updated - Symbol: ${state.currentCurrency.symbol}
                }
                if (state is CurrencyError) {
                  _showErrorSnackBar(
                    "Failed to load currency: ${state.message}",
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<HomeScreenUserDetailBloc, HomeScreenState>(
            builder: (context, state) {
              String userIncome = state is HomeScreenSuccess
                  ? state.userIncomeBalance.toStringAsFixed(0)
                  : "";
              String userExpense = state is HomeScreenSuccess
                  ? state.userExpenseBalance.toStringAsFixed(0)
                  : "";
              String userTotal = state is HomeScreenSuccess
                  ? state.userTotalBalance.toStringAsFixed(0)
                  : "";

              return CustomScrollView(
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(child: _buildHeaderSection(context)),

                  // Balance Card Section
                  SliverToBoxAdapter(
                    child: _buildBalanceCard(
                      context,
                      userTotal,
                      userIncome,
                      userExpense,
                    ),
                  ),

                  // Quick Actions Section
                  SliverToBoxAdapter(child: _buildQuickActions(context)),

                  // Spacing between sections
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Spending Insights Section
                  SliverToBoxAdapter(
                    child: _buildSpendingInsights(
                      context,
                      userIncome,
                      userExpense,
                    ),
                  ),
                  // Recent Transactions Header
                  SliverToBoxAdapter(child: _buildTransactionsHeader(context)),

                  // Recent Transactions List
                  _buildRecentTransactionsList(),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              CupertinoIcons.person_fill,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome!",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                userLocalName ?? "User",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage.withBloc()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    String userTotal,
    String userIncome,
    String userExpense,
  ) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        String currencySymbol = '₹';
        if (currencyState is CurrencyLoaded) {
          currencySymbol = currencyState.currentCurrency.symbol;
        }

        return Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor(context),
                AppTheme.secondaryColor(context),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Available Balance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              userTotal.isNotEmpty
                  ? Text(
                      "$currencySymbol $userTotal",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "$currencySymbol ------",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ).redacted(context: context, redact: true),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Income",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "$currencySymbol$userIncome",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expense",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "$currencySymbol$userExpense",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionItem(
                context,
                "Quick Income",
                Icons.arrow_downward,
                Colors.greenAccent,
                () => _showIncomeDialog(context),
              ),
              _buildQuickActionItem(
                context,
                "Quick Expense",
                Icons.arrow_upward,
                Colors.redAccent,
                () => _showExpenseDialog(context),
              ),
              _buildQuickActionItem(
                context,
                "Quick Scan",
                Icons.camera_alt,
                Colors.blueAccent,
                () => _navigateToQuickScan(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // HELPER METHODS: Add these methods to your _MainScreenState class

  void _showIncomeDialog(BuildContext context) {
    // Get the bloc instances from the current context BEFORE opening dialog
    final quickBloc = context.read<QuickExpenseOrIncomeBloc>();
    final addExpenseBloc = context.read<AddExpenseBloc>();

    // Load categories before showing dialog
    quickBloc.add(LoadCategories(false));

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider<QuickExpenseOrIncomeBloc>.value(value: quickBloc),
          BlocProvider<AddExpenseBloc>.value(value: addExpenseBloc),
        ],
        child: _buildQuickActionDialog(dialogContext, false),
      ),
    );
  }

  void _showExpenseDialog(BuildContext context) {
    // Get the bloc instances from the current context BEFORE opening dialog
    final quickBloc = context.read<QuickExpenseOrIncomeBloc>();
    final addExpenseBloc = context.read<AddExpenseBloc>();

    // Load categories before showing dialog
    quickBloc.add(LoadCategories(true));

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider<QuickExpenseOrIncomeBloc>.value(value: quickBloc),
          BlocProvider<AddExpenseBloc>.value(value: addExpenseBloc),
        ],
        child: _buildQuickActionDialog(dialogContext, true),
      ),
    );
  }

  // UPDATED DIALOG METHOD: Replace your _addQuickActionsIncomeExpense with this:

  Widget _buildQuickActionDialog(BuildContext context, bool expense) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        String currencySymbol = '₹';
        if (currencyState is CurrencyLoaded) {
          currencySymbol = currencyState.currentCurrency.symbol;
        }

        return BlocBuilder<QuickExpenseOrIncomeBloc, QuickExpenseOrIncomeState>(
          builder: (context, state) {
            List<String> finalCategoryList = [];
            String? selectedCategory;
            bool errorMsg = false;

            if (state is QuickExpenseOrIncomeLoaded) {
              finalCategoryList = state.categoriesList;
              selectedCategory = state.selectedCategory;
              errorMsg = state.showError;
            }

            return AlertDialog(
              title: Center(
                child: Text(
                  "Add Quick ${expense ? "Expense" : "Income"}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              content: SizedBox(
                height: 160,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _amountController,
                      hint: "amount (e.g ${currencySymbol}400.00)",
                      icon: FontAwesomeIcons.rupeeSign,
                      inputType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      maxLength: 10,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: expense
                              ? "Select category (e.g Rent)"
                              : "Select category (e.g Salary)",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.apps,
                              color: Colors.grey.shade500,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.primaryColor(context),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        value: selectedCategory,
                        items: finalCategoryList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          context.read<QuickExpenseOrIncomeBloc>().add(
                            UpdateSelectedCategory(value),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    errorMsg
                        ? const Text(
                            "fill all the fields",
                            style: TextStyle(color: Colors.red),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<QuickExpenseOrIncomeBloc>().add(ClearForm());
                    _amountController.clear();
                  },
                ),
                BlocListener<AddExpenseBloc, AddExpenseState>(
                  listener: (context, state) {
                    if (state is AddTransactionSuccess) {
                      Navigator.of(context).pop();
                      context.read<QuickExpenseOrIncomeBloc>().add(ClearForm());
                      _amountController.clear();
                      // The balance will be updated automatically by the listener in build method
                    }
                  },
                  child: TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      final check = _validateTextField(
                        expense,
                        selectedCategory,
                      );
                      if (!check) {
                        context.read<QuickExpenseOrIncomeBloc>().add(
                          ShowValidationError(),
                        );
                      }
                      // If validation passes, the transaction will be submitted
                      // and the BlocListener above will handle closing the dialog
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    Function onTap,
  ) {
    return GestureDetector(
      onTap: onTap as void Function(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingInsights(
    BuildContext context,
    String userIncome,
    String userExpense,
  ) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        String currencySymbol = '₹';
        if (currencyState is CurrencyLoaded) {
          currencySymbol = currencyState.currentCurrency.symbol;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Spending Insights",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInsightItem(
                    "Income",
                    "$currencySymbol$userIncome",
                    Colors.green,
                  ),
                  _buildInsightItem(
                    "Expense",
                    "$currencySymbol$userExpense",
                    Colors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Recent Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => _navigateToAllTransactions(context),
            child: const Text(
              "View All",
              style: TextStyle(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userTrancations,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[60],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[60],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).redacted(
                              context: context,
                              redact: true,
                              configuration: RedactedConfiguration(
                                redactedColor: Colors.grey[60],
                                defaultBorderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "################",
                                  style: TextStyle(
                                    color: Colors.grey[60],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).redacted(
                                  context: context,
                                  redact: true,
                                  configuration: RedactedConfiguration(
                                    redactedColor: Colors.grey[60],
                                    defaultBorderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                ),
                                Text(
                                  "##################",
                                  style: TextStyle(
                                    color: Colors.grey[60],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).redacted(
                                  context: context,
                                  redact: true,
                                  configuration: RedactedConfiguration(
                                    redactedColor: Colors.grey[60],
                                    defaultBorderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "000000",
                              style: TextStyle(
                                color: Colors.grey[60],
                                fontWeight: FontWeight.w500,
                              ),
                            ).redacted(
                              context: context,
                              redact: true,
                              configuration: RedactedConfiguration(
                                redactedColor: Colors.grey[60],
                                defaultBorderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Text(
                              "00 00 0000",
                              style: TextStyle(
                                color: Colors.grey[60],
                                fontWeight: FontWeight.w500,
                              ),
                            ).redacted(
                              context: context,
                              redact: true,
                              configuration: RedactedConfiguration(
                                redactedColor: Colors.grey[60],
                                defaultBorderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: 5),
          );
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: Text("No transactions found.")),
          );
        }
        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            DateTime? date;
            if (ds["date"] is Timestamp) {
              date = (ds["date"] as Timestamp).toDate();
            } else if (ds["date"] is String) {
              date = DateFormat('dd MM yyyy').parse(ds["date"]);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TransactionCard(
                    currentUser: widget.currentUser,
                    category: ds["category"],
                    amount: ds["amount"].toString(),
                    id: ds["trancationId"],
                    type: ds["type"],
                    date: ds["date"],
                    dateWord: formatFriendlyDate(date!),
                    imgUrl: ds["imageUrl"],
                    note: ds["note"],
                  ),
                ),
              ),
            );
          }, childCount: snapshot.data.docs.length),
        );
      },
    );
  }

  void _navigateToAllTransactions(BuildContext context) {
    // Get the existing bloc from the MultiBlocProvider
    final searchBloc = context.read<UserSearchTransactionBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) =>
            BlocProvider<UserSearchTransactionBloc>.value(
              value: searchBloc,
              child: ShowAllTransactions(userId: widget.currentUser),
            ),
      ),
    );
  }

  void _navigateToQuickScan(BuildContext context) {
    // Get the existing blocs from the MultiBlocProvider
    final addExpenseBloc = context.read<AddExpenseBloc>();
    final homeScreenBloc = context.read<HomeScreenUserDetailBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => MultiBlocProvider(
          providers: [
            BlocProvider<AddExpenseBloc>.value(value: addExpenseBloc),
            BlocProvider<HomeScreenUserDetailBloc>.value(value: homeScreenBloc),
          ],
          child: QuickScanScreen(currentUser: widget.currentUser),
        ),
      ),
    );
  }

  // ENHANCED validation with better error handling
  bool _validateTextField(bool expense, String? selectedCategory) {
    final value = _amountController.text.trim();
    final amount = double.tryParse(value);

    if (value.isEmpty || amount == null || amount <= 0) {
      _showErrorSnackBar("Please enter a valid amount");
      return false;
    } else if (selectedCategory == null || selectedCategory.isEmpty) {
      _showErrorSnackBar("Please select a category");
      return false;
    } else {
      try {
        String transactionId = randomAlphaNumeric(15);
        final addExpenseBloc = context.read<AddExpenseBloc>();
        addExpenseBloc.add(
          SubmitTrancation(
            addTrancationModel: AddTrancationModel(
              transactionId: transactionId,
              amount: amount,
              type: expense ? "Expense" : "Income",
              date: DateTime.now(),
              createdat: Timestamp.now(),
              category: selectedCategory,
              imageUrl: "",
              note: "",
            ),
          ),
        );

        // Don't show success message here - it will be handled by the BlocListener
        // Don't refresh here either - it will be handled automatically
        return true;
      } catch (e) {
        _showErrorSnackBar("Error processing transaction: ${e.toString()}");
        return false;
      }
    }
  }

  // HELPER METHODS FOR SNACKBARS: Add these to your _MainScreenState class

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLength = 30,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? inputType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
        maxLength: maxLength,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          prefixIcon: Container(
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: Colors.grey.shade500, size: 20),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor(context),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
