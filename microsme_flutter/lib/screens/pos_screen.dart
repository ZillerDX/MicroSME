import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/app_state.dart';
import '../models/product.dart';
import 'pos_screen_cart.dart';

String _getProductEmoji(String productName) {
  final name = productName.toLowerCase();
  if (name.contains('coffee')) return '☕';
  if (name.contains('tea')) return '🍵';
  if (name.contains('cake')) return '🍰';
  if (name.contains('cookie')) return '🍪';
  if (name.contains('sandwich')) return '🥪';
  if (name.contains('water')) return '💧';
  if (name.contains('juice')) return '🧃';
  if (name.contains('soda')) return '🥤';
  if (name.contains('bread')) return '🍞';
  if (name.contains('donut')) return '🍩';
  return '📦';
}

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final products = state.products;

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
              child: const Row(
                children: [
                  Text(
                    'Point of Sale',
                    style: TextStyle(
                      fontSize: AppFontSizes.xl,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                    // Section Title
                    const Text(
                      'Product Grid',
                      style: TextStyle(
                        fontSize: AppFontSizes.lg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Product Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _buildProductCard(context, state, product);
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Cart Section
                    const Text(
                      'Current Cart',
                      style: TextStyle(
                        fontSize: AppFontSizes.lg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    buildCartSection(context, state),
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

  Widget _buildProductCard(BuildContext context, AppState state, Product product) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: product.stockQuantity > 0
              ? () {
                  state.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart!'),
                      duration: const Duration(milliseconds: 800),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.emoji ?? _getProductEmoji(product.name),
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: AppFontSizes.md,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${AppConstants.currency}${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: AppFontSizes.lg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: product.isLowStock
                        ? AppColors.warning
                        : product.stockQuantity <= 0
                            ? AppColors.error
                            : AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.stockQuantity <= 0
                        ? 'Out'
                        : 'Stock: ${product.stockQuantity}',
                    style: TextStyle(
                      fontSize: AppFontSizes.xs,
                      fontWeight: FontWeight.w600,
                      color: product.isLowStock || product.stockQuantity <= 0
                          ? Colors.white
                          : AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
