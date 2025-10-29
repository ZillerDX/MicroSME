import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../services/app_state.dart';
import '../models/expense.dart';
import 'pos_screen_cart.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final dailySummary = state.getDailySummaryForDateRange(_selectedStartDate, _selectedEndDate);
        final recentTransactions = _getRecentTransactions(state, _selectedStartDate, _selectedEndDate);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: AppFontSizes.xl,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Colors.white),
                            onPressed: () => _showLoyaltySettingsDialog(context),
                            tooltip: 'Loyalty Settings',
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(DateTime.now()),
                            style: const TextStyle(
                              fontSize: AppFontSizes.md,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Business Overview',
                            style: TextStyle(
                              fontSize: AppFontSizes.sm,
                              color: Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => _showDateRangePicker(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppBorderRadius.full),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    _selectedStartDate == _selectedEndDate
                                        ? DateFormat('MMM dd').format(_selectedStartDate)
                                        : '${DateFormat('MMM dd').format(_selectedStartDate)} - ${DateFormat('MMM dd').format(_selectedEndDate)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSizes.xs,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Stats Cards
                        _buildQuickStatsGrid(dailySummary),

                        const SizedBox(height: AppSpacing.lg),

                        // Loyalty Program Info
                        _buildLoyaltyProgramCard(context),

                        const SizedBox(height: AppSpacing.lg),

                        // Daily Summary
                        const Text(
                          'Financial Summary',
                          style: TextStyle(
                            fontSize: AppFontSizes.lg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.1),
                                AppColors.cardBackground,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildSummaryRow(
                                '💰 Revenue',
                                dailySummary['revenue'] ?? 0.0,
                                AppColors.success,
                                '${dailySummary['salesCount'] ?? 0} sales',
                              ),
                              const Divider(),
                              _buildSummaryRow(
                                '💸 Expenses',
                                dailySummary['expenses'] ?? 0.0,
                                AppColors.error,
                                '${dailySummary['expensesCount'] ?? 0} expenses',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.only(top: AppSpacing.md),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                                  ),
                                ),
                                child: _buildSummaryRow(
                                  '📊 Net Profit',
                                  dailySummary['profit'] ?? 0.0,
                                  AppColors.primary,
                                  '',
                                  isTotal: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Recent Transactions Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedStartDate == _selectedEndDate
                                  ? 'Transactions'
                                  : 'Transactions (${DateFormat('MMM dd').format(_selectedStartDate)} - ${DateFormat('MMM dd').format(_selectedEndDate)})',
                              style: const TextStyle(
                                fontSize: AppFontSizes.lg,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddExpenseDialog(context, state),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add Expense'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Transactions
                        if (recentTransactions.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  const Text(
                                    'No transactions today',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.md,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...recentTransactions.map((txn) => _buildTransactionCard(txn)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStatsGrid(Map<String, dynamic> dailySummary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Today\'s Sales',
          '${dailySummary['salesCount'] ?? 0}',
          Icons.shopping_cart,
          AppColors.success,
        ),
        _buildStatCard(
          'Revenue',
          '${AppConstants.currency}${(dailySummary['revenue'] ?? 0.0).toStringAsFixed(0)}',
          Icons.trending_up,
          AppColors.primary,
        ),
        _buildStatCard(
          'Expenses',
          '${AppConstants.currency}${(dailySummary['expenses'] ?? 0.0).toStringAsFixed(0)}',
          Icons.money_off,
          AppColors.error,
        ),
        _buildStatCard(
          'Net Profit',
          '${AppConstants.currency}${(dailySummary['profit'] ?? 0.0).toStringAsFixed(0)}',
          Icons.account_balance_wallet,
          AppColors.secondary,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: AppFontSizes.xl,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppFontSizes.xs,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyProgramCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Text(
                  'Loyalty Rewards Program',
                  style: TextStyle(
                    fontSize: AppFontSizes.lg,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _showLoyaltySettingsDialog(context),
                tooltip: 'Edit Settings',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How Customers Earn Points:',
                  style: TextStyle(
                    fontSize: AppFontSizes.md,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildLoyaltyInfoRow(
                  Icons.shopping_bag,
                  'Spend ${AppConstants.currency}${LoyaltySettings.pointsPerAmount}',
                  'Earn 1 Point',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildLoyaltyInfoRow(
                  Icons.redeem,
                  'Collect ${LoyaltySettings.redemptionRate} Points',
                  'Get ${AppConstants.currency}${LoyaltySettings.redemptionValue} Discount',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppBorderRadius.full),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Points accumulate automatically with each purchase',
                  style: TextStyle(
                    fontSize: AppFontSizes.xs,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppFontSizes.sm,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: AppFontSizes.xs,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward, color: Colors.white70, size: 16),
      ],
    );
  }

  List<Map<String, dynamic>> _getRecentTransactions(AppState state, DateTime startDate, DateTime endDate) {
    final List<Map<String, dynamic>> transactions = [];

    // Add sales as transactions
    for (var sale in state.sales) {
      if (sale.createdAt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          sale.createdAt.isBefore(endDate.add(const Duration(days: 1)))) {
        transactions.add({
          'type': 'Sale',
          'icon': Icons.point_of_sale,
          'amount': sale.total,
          'time': DateFormat('MMM dd, h:mm a').format(sale.createdAt),
          'timestamp': sale.createdAt,
          'details': '${sale.items.length} items',
        });
      }
    }

    // Add expenses as transactions
    for (var expense in state.expenses) {
      if (expense.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          expense.date.isBefore(endDate.add(const Duration(days: 1)))) {
        transactions.add({
          'type': 'Expense',
          'icon': Icons.shopping_bag_outlined,
          'amount': -expense.amount,
          'time': DateFormat('MMM dd, h:mm a').format(expense.date),
          'timestamp': expense.date,
          'details': expense.description,
        });
      }
    }

    // Sort by timestamp (most recent first)
    transactions.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    return transactions;
  }

  void _showDateRangePicker(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Date Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.today, color: AppColors.primary),
              title: const Text('Today'),
              onTap: () {
                setState(() {
                  _selectedStartDate = DateTime.now();
                  _selectedEndDate = DateTime.now();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_week, color: AppColors.primary),
              title: const Text('Last 7 Days'),
              onTap: () {
                setState(() {
                  _selectedEndDate = DateTime.now();
                  _selectedStartDate = DateTime.now().subtract(const Duration(days: 6));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: AppColors.primary),
              title: const Text('This Month'),
              onTap: () {
                final now = DateTime.now();
                setState(() {
                  _selectedStartDate = DateTime(now.year, now.month, 1);
                  _selectedEndDate = now;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range, color: AppColors.primary),
              title: const Text('Custom Range'),
              onTap: () async {
                Navigator.pop(context);
                final pickedRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: DateTimeRange(
                    start: _selectedStartDate,
                    end: _selectedEndDate,
                  ),
                );
                if (pickedRange != null) {
                  setState(() {
                    _selectedStartDate = pickedRange.start;
                    _selectedEndDate = pickedRange.end;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, Color color, String subtitle, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTotal ? AppFontSizes.lg : AppFontSizes.md,
                    fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: AppFontSizes.xs,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${AppConstants.currency}${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? AppFontSizes.xxl : AppFontSizes.xl,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> txn) {
    final isPositive = txn['amount'] > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border(
          left: BorderSide(
            color: isPositive ? AppColors.success : AppColors.error,
            width: 3,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isPositive ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Icon(
              txn['icon'] as IconData,
              color: isPositive ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn['type'],
                  style: const TextStyle(
                    fontSize: AppFontSizes.md,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  txn['details'] ?? '',
                  style: const TextStyle(
                    fontSize: AppFontSizes.xs,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  txn['time'],
                  style: const TextStyle(
                    fontSize: AppFontSizes.xs,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${isPositive ? '+' : ''}${AppConstants.currency}${txn['amount'].abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: AppFontSizes.lg,
              fontWeight: FontWeight.bold,
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, AppState state) {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Office Supplies',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount (${AppConstants.currency})',
                hintText: '0',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final description = descriptionController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0;

              if (description.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a description'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              final expense = Expense(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: description,
                amount: amount,
                createdAt: DateTime.now(),
              );

              await state.addExpense(expense);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Expense added successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showLoyaltySettingsDialog(BuildContext context) {
    final pointsPerAmountController = TextEditingController(
      text: LoyaltySettings.pointsPerAmount.toString(),
    );
    final redemptionRateController = TextEditingController(
      text: LoyaltySettings.redemptionRate.toString(),
    );
    final redemptionValueController = TextEditingController(
      text: LoyaltySettings.redemptionValue.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.settings, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Loyalty Program Settings'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customize how customers earn and redeem points',
                    style: TextStyle(
                      fontSize: AppFontSizes.sm,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: pointsPerAmountController,
                    decoration: InputDecoration(
                      labelText: 'Spend Amount for 1 Point',
                      hintText: '50',
                      helperText: 'Customer spends this amount to earn 1 point',
                      prefixText: AppConstants.currency,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: redemptionRateController,
                    decoration: const InputDecoration(
                      labelText: 'Points for Redemption',
                      hintText: '10',
                      helperText: 'Number of points needed for discount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: redemptionValueController,
                    decoration: InputDecoration(
                      labelText: 'Discount Value',
                      hintText: '50',
                      helperText: 'Discount amount when redeeming points',
                      prefixText: AppConstants.currency,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, size: 20, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Example Calculation:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Customer spends ${AppConstants.currency}${pointsPerAmountController.text.isEmpty ? "50" : pointsPerAmountController.text} = Earns 1 point',
                          style: const TextStyle(fontSize: AppFontSizes.sm),
                        ),
                        Text(
                          'Collect ${redemptionRateController.text.isEmpty ? "10" : redemptionRateController.text} points = Get ${AppConstants.currency}${redemptionValueController.text.isEmpty ? "50" : redemptionValueController.text} discount',
                          style: const TextStyle(fontSize: AppFontSizes.sm),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final pointsPerAmount = int.tryParse(pointsPerAmountController.text) ?? 50;
                  final redemptionRate = int.tryParse(redemptionRateController.text) ?? 10;
                  final redemptionValue = int.tryParse(redemptionValueController.text) ?? 50;

                  if (pointsPerAmount <= 0 || redemptionRate <= 0 || redemptionValue <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid positive numbers'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }

                  LoyaltySettings.pointsPerAmount = pointsPerAmount;
                  LoyaltySettings.redemptionRate = redemptionRate;
                  LoyaltySettings.redemptionValue = redemptionValue;

                  Navigator.pop(context);

                  // Show updated values
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Loyalty settings updated!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${AppConstants.currency}$pointsPerAmount = 1 point • $redemptionRate points = ${AppConstants.currency}$redemptionValue off',
                            style: const TextStyle(fontSize: AppFontSizes.xs),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 4),
                    ),
                  );

                  // Trigger rebuild to show new values in the card
                  (context as Element).markNeedsBuild();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }
}
