
class ExpenseCategory {
  final String name;
  final double amount;

  ExpenseCategory({
    required this.name,
    required this.amount,
  });
}

class MonthlyData {
  final String day;
  final double amount;

  MonthlyData({
    required this.day,
    required this.amount,
  });
}




class DashboardData {
  static const double totalIncome = 5200.0;
  static const double totalExpenses = 3800.0;
  static const double monthlySpending = 3800.0;
  
  static List<ExpenseCategory> categories = [
    ExpenseCategory(name: 'Food', amount: 800.0),
    ExpenseCategory(name: 'Transport', amount: 450.0),
    ExpenseCategory(name: 'Entertainment', amount: 320.0),
    ExpenseCategory(name: 'Utilities', amount: 280.0),
    ExpenseCategory(name: 'Shopping', amount: 650.0),
    ExpenseCategory(name: 'Healthcare', amount: 200.0),
    ExpenseCategory(name: 'Education', amount: 150.0),
    ExpenseCategory(name: 'Others', amount: 950.0,),
  ];



}
