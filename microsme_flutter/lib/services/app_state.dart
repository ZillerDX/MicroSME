import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../models/customer.dart';
import '../models/expense.dart';
import '../database/database_helper.dart';
import '../constants/app_constants.dart';

class AppState extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  // State
  List<Product> _products = [];
  List<Sale> _sales = [];
  List<Customer> _customers = [];
  List<Expense> _expenses = [];

  // Cart state
  final Map<String, CartItem> _cart = {};
  Customer? _selectedCustomer;
  double _cartDiscount = 0;

  // Getters
  List<Product> get products => _products;
  List<Sale> get sales => _sales;
  List<Customer> get customers => _customers;
  List<Expense> get expenses => _expenses;
  Map<String, CartItem> get cart => _cart;
  Customer? get selectedCustomer => _selectedCustomer;
  double get cartDiscount => _cartDiscount;

  // Cart calculations
  double get cartSubtotal => _cart.values.fold(0, (sum, item) => sum + item.subtotal);
  double get cartTotal => cartSubtotal - _cartDiscount;
  int get cartItemCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);

  // Customer statistics (calculated from sales)
  double getCustomerTotalSpent(String customerId) {
    return _sales
        .where((sale) => sale.customerId == customerId)
        .fold(0.0, (sum, sale) => sum + sale.total);
  }

  int getCustomerSalesCount(String customerId) {
    return _sales.where((sale) => sale.customerId == customerId).length;
  }

  Map<String, dynamic> getDailySummaryForDateRange(DateTime startDate, DateTime endDate) {
    final filteredSales = _sales.where((sale) {
      return sale.createdAt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          sale.createdAt.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    final filteredExpenses = _expenses.where((expense) {
      return expense.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          expense.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    final revenue = filteredSales.fold(0.0, (sum, sale) => sum + sale.total);
    final expenses = filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

    return {
      'revenue': revenue,
      'expenses': expenses,
      'profit': revenue - expenses,
      'salesCount': filteredSales.length,
      'expensesCount': filteredExpenses.length,
    };
  }

  // Initialize
  Future<void> initialize() async {
    await loadAllData();

    // Add sample data if empty
    if (_products.isEmpty) {
      await _addSampleData();
    }
  }

  Future<void> _addSampleData() async {
    final sampleProducts = [
      Product(
        id: _uuid.v4(),
        name: 'Coffee',
        price: 50,
        stockQuantity: 100,
        lowStockThreshold: 10,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Tea',
        price: 45,
        stockQuantity: 80,
        lowStockThreshold: 10,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Cake',
        price: 80,
        stockQuantity: 25,
        lowStockThreshold: 10,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Cookie',
        price: 30,
        stockQuantity: 50,
        lowStockThreshold: 15,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Sandwich',
        price: 60,
        stockQuantity: 40,
        lowStockThreshold: 10,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Water',
        price: 20,
        stockQuantity: 150,
        lowStockThreshold: 20,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    for (var product in sampleProducts) {
      await _db.insertProduct(product);
    }

    await loadAllData();
  }

  Future<void> loadAllData() async {
    _products = await _db.getAllProducts();
    _sales = await _db.getAllSales();
    _customers = await _db.getAllCustomers();
    _expenses = await _db.getAllExpenses();
    notifyListeners();
  }

  // Products
  Future<void> addProduct(dynamic productOrName, [double? price, int? stock, int? lowStock]) async {
    Product product;

    if (productOrName is Product) {
      // Called with Product object
      product = productOrName;
    } else if (productOrName is String) {
      // Called with individual parameters
      product = Product(
        id: _uuid.v4(),
        name: productOrName,
        price: price!,
        stockQuantity: stock!,
        lowStockThreshold: lowStock,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      throw ArgumentError('First argument must be either a Product or a String');
    }

    await _db.insertProduct(product);
    await loadAllData();
  }

  Future<void> updateProduct(Product product) async {
    await _db.updateProduct(product);
    await loadAllData();
  }

  Future<void> deleteProduct(String id) async {
    await _db.deleteProduct(id);
    await loadAllData();
  }

  // Cart operations
  void addToCart(Product product) {
    if (_cart.containsKey(product.id)) {
      final item = _cart[product.id]!;
      _cart[product.id] = CartItem(
        productId: item.productId,
        productName: item.productName,
        price: item.price,
        quantity: item.quantity + 1,
      );
    } else {
      _cart[product.id] = CartItem(
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void updateCartItemQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      _cart.remove(productId);
    } else {
      final item = _cart[productId]!;
      _cart[productId] = CartItem(
        productId: item.productId,
        productName: item.productName,
        price: item.price,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void setCartDiscount(double discount) {
    _cartDiscount = discount;
    notifyListeners();
  }

  void setSelectedCustomer(Customer? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _cartDiscount = 0;
    _selectedCustomer = null;
    notifyListeners();
  }

  Future<void> completeSale(PaymentMethod paymentMethod) async {
    if (_cart.isEmpty) return;

    final sale = Sale(
      id: _uuid.v4(),
      items: _cart.values.toList(),
      subtotal: cartSubtotal,
      discountAmount: _cartDiscount,
      total: cartTotal,
      paymentMethod: paymentMethod,
      customerId: _selectedCustomer?.id,
      customerName: _selectedCustomer?.name,
      createdAt: DateTime.now(),
    );

    await _db.insertSale(sale);

    // Update product stock
    for (var item in _cart.values) {
      final product = _products.firstWhere((p) => p.id == item.productId);
      final updatedProduct = product.copyWith(
        stockQuantity: product.stockQuantity - item.quantity,
        updatedAt: DateTime.now(),
      );
      await _db.updateProduct(updatedProduct);
    }

    // Update customer if selected
    if (_selectedCustomer != null) {
      final pointsEarned = (cartTotal / AppConstants.defaultPointsPerAmount).floor();
      final updatedCustomer = _selectedCustomer!.copyWith(
        points: _selectedCustomer!.points + pointsEarned,
        updatedAt: DateTime.now(),
      );
      await _db.updateCustomer(updatedCustomer);
    }

    clearCart();
    await loadAllData();
  }

  Future<void> completeSaleWithCustomer(
    PaymentMethod paymentMethod,
    String? customerId,
    String? customerName,
    int? pointsAwarded,
  ) async {
    if (_cart.isEmpty) return;

    final sale = Sale(
      id: _uuid.v4(),
      items: _cart.values.toList(),
      subtotal: cartSubtotal,
      discountAmount: _cartDiscount,
      total: cartTotal,
      paymentMethod: paymentMethod,
      customerId: customerId,
      customerName: customerName,
      pointsAwarded: pointsAwarded,
      createdAt: DateTime.now(),
    );

    await _db.insertSale(sale);

    // Update product stock
    for (var item in _cart.values) {
      final product = _products.firstWhere((p) => p.id == item.productId);
      final updatedProduct = product.copyWith(
        stockQuantity: product.stockQuantity - item.quantity,
        updatedAt: DateTime.now(),
      );
      await _db.updateProduct(updatedProduct);
    }

    clearCart();
    await loadAllData();
  }

  Future<void> updateCustomerPoints(String customerId, int newPoints) async {
    final customer = _customers.firstWhere((c) => c.id == customerId);
    final updatedCustomer = customer.copyWith(
      points: newPoints,
      updatedAt: DateTime.now(),
    );
    await _db.updateCustomer(updatedCustomer);
    await loadAllData();
  }

  // Customers
  Future<void> addCustomer(String phoneNumber, String? name) async {
    final customer = Customer(
      id: _uuid.v4(),
      phoneNumber: phoneNumber,
      name: name,
      points: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _db.insertCustomer(customer);
    await loadAllData();
  }

  Future<void> updateCustomer(Customer customer) async {
    await _db.updateCustomer(customer);
    await loadAllData();
  }

  Future<void> deleteCustomer(String id) async {
    await _db.deleteCustomer(id);
    await loadAllData();
  }

  // Expenses
  Future<void> addExpense(dynamic expenseOrTitle, [double? amount, String? category]) async {
    Expense expense;

    if (expenseOrTitle is Expense) {
      // Called with Expense object
      expense = expenseOrTitle;
    } else if (expenseOrTitle is String) {
      // Called with individual parameters
      expense = Expense(
        id: _uuid.v4(),
        title: expenseOrTitle,
        amount: amount!,
        category: category,
        createdAt: DateTime.now(),
      );
    } else {
      throw ArgumentError('First argument must be either an Expense or a String');
    }

    await _db.insertExpense(expense);
    await loadAllData();
  }

  // Daily Summary
  Map<String, dynamic> getDailySummary(DateTime date) {
    final today = date;
    double revenue = 0;
    int salesCount = 0;
    double expenses = 0;
    int expensesCount = 0;

    // Calculate revenue from sales
    for (var sale in _sales) {
      if (_isSameDay(sale.createdAt, today)) {
        revenue += sale.total;
        salesCount++;
      }
    }

    // Calculate total expenses
    for (var expense in _expenses) {
      if (_isSameDay(expense.createdAt, today)) {
        expenses += expense.amount;
        expensesCount++;
      }
    }

    final profit = revenue - expenses;

    return {
      'revenue': revenue,
      'expenses': expenses,
      'profit': profit,
      'salesCount': salesCount,
      'expensesCount': expensesCount,
    };
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
