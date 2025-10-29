import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/app_state.dart';
import '../models/sale.dart';
import '../models/customer.dart';

// Global settings for loyalty program (can be customized)
class LoyaltySettings {
  static int pointsPerAmount = AppConstants.defaultPointsPerAmount; // Spend X to get 1 point
  static int redemptionRate = AppConstants.defaultRedemptionRate; // X points for redemption
  static int redemptionValue = AppConstants.defaultRedemptionValue; // Discount value in currency
}

Widget buildCartSection(BuildContext context, AppState state) {
  final cart = state.cart;

  if (cart.isEmpty) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Cart is empty',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppFontSizes.md,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Tap products above to add to cart',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppFontSizes.sm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.cardBackground,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cart (${state.cartItemCount} items)',
              style: const TextStyle(
                fontSize: AppFontSizes.lg,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => state.clearCart(),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear'),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 8),
        ...cart.values.map((item) => _buildCartItem(context, state, item)),
        const SizedBox(height: 16),
        _buildTotals(state),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _showCheckoutDialog(context, state),
            icon: const Icon(Icons.payment),
            label: const Text(
              'Complete Sale',
              style: TextStyle(
                fontSize: AppFontSizes.md,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCartItem(BuildContext context, AppState state, dynamic item) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${AppConstants.currency}${item.price} × ${item.quantity}',
                style: const TextStyle(
                  fontSize: AppFontSizes.sm,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: () => state.updateCartItemQuantity(
                item.productId,
                item.quantity - 1,
              ),
              color: AppColors.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () => state.updateCartItemQuantity(
                item.productId,
                item.quantity + 1,
              ),
              color: AppColors.success,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          '${AppConstants.currency}${item.subtotal.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTotals(AppState state) {
  return Column(
    children: [
      const Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Subtotal:', style: TextStyle(fontSize: AppFontSizes.md)),
          Text(
            '${AppConstants.currency}${state.cartSubtotal.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: AppFontSizes.md, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total:',
            style: TextStyle(fontSize: AppFontSizes.lg, fontWeight: FontWeight.bold),
          ),
          Text(
            '${AppConstants.currency}${state.cartTotal.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: AppFontSizes.xl,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ],
  );
}

void _showCheckoutDialog(BuildContext context, AppState state) {
  Customer? selectedCustomer;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        // Calculate points that will be awarded
        int pointsToAward = 0;
        if (selectedCustomer != null) {
          pointsToAward = (state.cartTotal / LoyaltySettings.pointsPerAmount).floor();
        }

        return AlertDialog(
          title: const Text('Complete Sale'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Amount
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: AppFontSizes.sm,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${AppConstants.currency}${state.cartTotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: AppFontSizes.xxl,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Customer Selection
                  const Text(
                    'Customer (Optional)',
                    style: TextStyle(
                      fontSize: AppFontSizes.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  if (selectedCustomer == null)
                    InkWell(
                      onTap: () async {
                        final customer = await _showCustomerSearchDialog(context, state);
                        if (customer != null) {
                          setState(() {
                            selectedCustomer = customer;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.person_search, color: AppColors.textSecondary),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              'Search for customer...',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        border: Border.all(color: AppColors.success),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                selectedCustomer!.displayName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: AppFontSizes.lg,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCustomer!.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${selectedCustomer!.points} points',
                                  style: const TextStyle(
                                    fontSize: AppFontSizes.sm,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedCustomer = null;
                              });
                            },
                            color: AppColors.error,
                          ),
                        ],
                      ),
                    ),

                  // Points Info
                  if (selectedCustomer != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withValues(alpha: 0.1),
                            Colors.blue.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars, color: Colors.purple, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Will earn +$pointsToAward points',
                              style: const TextStyle(
                                fontSize: AppFontSizes.sm,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: AppFontSizes.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _completeSaleWithCustomer(
                  context,
                  state,
                  PaymentMethod.cash,
                  selectedCustomer,
                  pointsToAward,
                );
              },
              icon: const Icon(Icons.money),
              label: const Text('Cash'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _completeSaleWithCustomer(
                  context,
                  state,
                  PaymentMethod.transfer,
                  selectedCustomer,
                  pointsToAward,
                );
              },
              icon: const Icon(Icons.account_balance),
              label: const Text('Transfer'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        );
      },
    ),
  );
}

Future<Customer?> _showCustomerSearchDialog(BuildContext context, AppState state) async {
  final searchController = TextEditingController();

  return showDialog<Customer>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final searchQuery = searchController.text.toLowerCase();
        final filteredCustomers = state.customers.where((customer) {
          return customer.displayName.toLowerCase().contains(searchQuery) ||
              customer.phoneNumber.contains(searchQuery);
        }).toList();

        return AlertDialog(
          title: const Text('Select Customer'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: filteredCustomers.isEmpty
                      ? const Center(
                          child: Text(
                            'No customers found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final customer = filteredCustomers[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                                child: Text(
                                  customer.displayName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(customer.displayName),
                              subtitle: Text('${customer.phoneNumber} • ${customer.points} points'),
                              onTap: () {
                                Navigator.pop(context, customer);
                              },
                            );
                          },
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
            ElevatedButton.icon(
              onPressed: () async {
                final newCustomer = await _showQuickAddCustomerDialog(context, state);
                if (newCustomer != null && context.mounted) {
                  Navigator.pop(context, newCustomer);
                }
              },
              icon: const Icon(Icons.person_add),
              label: const Text('New Customer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Future<Customer?> _showQuickAddCustomerDialog(BuildContext context, AppState state) async {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  return showDialog<Customer>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('New Customer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              hintText: '081-234-5678',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name (Optional)',
              hintText: 'John Doe',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
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
            final phone = phoneController.text.trim();
            final name = nameController.text.trim();

            if (phone.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a phone number'),
                  backgroundColor: AppColors.error,
                ),
              );
              return;
            }

            // Create the customer
            await state.addCustomer(phone, name.isEmpty ? null : name);

            // Find the newly created customer and return it
            final newCustomer = state.customers.firstWhere(
              (c) => c.phoneNumber == phone,
            );

            if (context.mounted) {
              Navigator.pop(context, newCustomer);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Create'),
        ),
      ],
    ),
  );
}

Future<void> _completeSaleWithCustomer(
  BuildContext context,
  AppState state,
  PaymentMethod paymentMethod,
  Customer? customer,
  int pointsToAward,
) async {
  // Complete the sale with customer info
  await state.completeSaleWithCustomer(
    paymentMethod,
    customer?.id,
    customer?.name,
    pointsToAward > 0 ? pointsToAward : null,
  );

  // Award points to customer
  if (customer != null && pointsToAward > 0) {
    await state.updateCustomerPoints(customer.id, customer.points + pointsToAward);
  }

  if (context.mounted) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sale completed successfully!'),
                  if (customer != null && pointsToAward > 0)
                    Text(
                      '+$pointsToAward points awarded to ${customer.displayName}',
                      style: const TextStyle(fontSize: AppFontSizes.xs),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
