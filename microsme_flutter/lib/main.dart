import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'services/app_state.dart';
import 'screens/pos_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/accounting_screen.dart';
import 'screens/crm_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    POSScreen(),
    InventoryScreen(),
    AccountingScreen(),
    CRMScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.cardBackground,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Text('💰', style: TextStyle(fontSize: 24)),
            label: 'POS',
          ),
          BottomNavigationBarItem(
            icon: Text('📦', style: TextStyle(fontSize: 24)),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Text('📊', style: TextStyle(fontSize: 24)),
            label: 'Accounting',
          ),
          BottomNavigationBarItem(
            icon: Text('👥', style: TextStyle(fontSize: 24)),
            label: 'Customers',
          ),
        ],
      ),
    );
  }
}
