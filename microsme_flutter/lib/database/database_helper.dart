import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/product.dart';
import '../models/sale.dart';
import '../models/customer.dart';
import '../models/expense.dart';
import '../constants/app_constants.dart';

// Conditional imports for web support
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _initialized = false;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize database factory for web
    if (kIsWeb && !_initialized) {
      databaseFactory = databaseFactoryFfiWeb;
      _initialized = true;
    }

    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      // For web, use a simple database name
      return await openDatabase(
        filePath,
        version: AppConstants.dbVersion,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    } else {
      // For mobile/desktop, use the standard path
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: AppConstants.dbVersion,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE products (
  id $idType,
  name $textType,
  price $realType,
  stock_quantity $intType,
  low_stock_threshold INTEGER,
  emoji TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
''');

    await db.execute('''
CREATE TABLE sales (
  id $idType,
  items $textType,
  subtotal $realType,
  discount_amount $realType,
  total $realType,
  payment_method $textType,
  customer_id TEXT,
  customer_name TEXT,
  points_awarded INTEGER,
  points_redeemed INTEGER,
  created_at INTEGER NOT NULL
)
''');

    await db.execute('''
CREATE TABLE customers (
  id $idType,
  phone_number $textType,
  name TEXT,
  points $intType,
  total_spent $realType,
  sales_count $intType,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
''');

    await db.execute('''
CREATE TABLE expenses (
  id $idType,
  title $textType,
  amount $realType,
  category TEXT,
  created_at INTEGER NOT NULL
)
''');

    // Create indexes
    await db.execute('CREATE INDEX idx_sales_created_at ON sales(created_at)');
    await db.execute('CREATE INDEX idx_customers_phone ON customers(phone_number)');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add emoji column to products table
      await db.execute('ALTER TABLE products ADD COLUMN emoji TEXT');
    }
  }

  // Products CRUD
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query('products', orderBy: 'name ASC');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Sales CRUD
  Future<void> insertSale(Sale sale) async {
    final db = await database;
    final map = sale.toMap();
    map['items'] = jsonEncode(map['items']); // Convert list to JSON string
    await db.insert('sales', map);
  }

  Future<List<Sale>> getAllSales() async {
    final db = await database;
    final result = await db.query('sales', orderBy: 'created_at DESC');
    return result.map((map) {
      final copy = Map<String, dynamic>.from(map);
      copy['items'] = jsonDecode(copy['items']); // Parse JSON string to list
      return Sale.fromMap(copy);
    }).toList();
  }

  Future<List<Sale>> getSalesByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.query(
      'sales',
      where: 'created_at >= ? AND created_at < ?',
      whereArgs: [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch],
      orderBy: 'created_at DESC',
    );

    return result.map((map) {
      final copy = Map<String, dynamic>.from(map);
      copy['items'] = jsonDecode(copy['items']);
      return Sale.fromMap(copy);
    }).toList();
  }

  // Customers CRUD
  Future<void> insertCustomer(Customer customer) async {
    final db = await database;
    await db.insert('customers', customer.toMap());
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final result = await db.query('customers', orderBy: 'name ASC');
    return result.map((map) => Customer.fromMap(map)).toList();
  }

  Future<Customer?> getCustomerByPhone(String phoneNumber) async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'phone_number = ?',
      whereArgs: [phoneNumber],
    );
    if (result.isEmpty) return null;
    return Customer.fromMap(result.first);
  }

  Future<void> updateCustomer(Customer customer) async {
    final db = await database;
    await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> deleteCustomer(String id) async {
    final db = await database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // Expenses CRUD
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final result = await db.query('expenses', orderBy: 'created_at DESC');
    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<List<Expense>> getExpensesByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.query(
      'expenses',
      where: 'created_at >= ? AND created_at < ?',
      whereArgs: [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch],
      orderBy: 'created_at DESC',
    );

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  // Daily Summary
  Future<DailySummary> getDailySummary(DateTime date) async {
    final sales = await getSalesByDate(date);
    final expenses = await getExpensesByDate(date);

    final totalRevenue = sales.fold<double>(0, (sum, sale) => sum + sale.total);
    final totalExpenses = expenses.fold<double>(0, (sum, exp) => sum + exp.amount);
    final netProfit = totalRevenue - totalExpenses;

    return DailySummary(
      date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      totalRevenue: totalRevenue,
      totalExpenses: totalExpenses,
      netProfit: netProfit,
      salesCount: sales.length,
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
