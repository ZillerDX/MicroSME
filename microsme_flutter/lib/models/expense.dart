class Expense {
  final String id;
  final String title;
  final double amount;
  final String? category;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    this.category,
    required this.createdAt,
  });

  // Convenience getters
  String get description => title;
  DateTime get date => createdAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

class DailySummary {
  final String date;
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;
  final int salesCount;

  DailySummary({
    required this.date,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netProfit,
    required this.salesCount,
  });
}
