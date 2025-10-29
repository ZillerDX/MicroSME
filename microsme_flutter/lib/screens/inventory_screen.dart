import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/app_state.dart';
import '../models/product.dart';
import '../widgets/emoji_picker.dart';

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

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

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
                  child: Row(
                    children: [
                      const Text(
                        'Inventory',
                        style: TextStyle(
                          fontSize: AppFontSizes.xl,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${products.length} Products',
                        style: const TextStyle(
                          fontSize: AppFontSizes.md,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              const Text(
                                'No products yet',
                                style: TextStyle(
                                  fontSize: AppFontSizes.lg,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              const Text(
                                'Tap + to add your first product',
                                style: TextStyle(
                                  fontSize: AppFontSizes.sm,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _buildProductCard(context, state, product);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showProductDialog(context, state),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Product',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, AppState state, Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: product.isLowStock
            ? const Border(
                left: BorderSide(color: AppColors.warning, width: 4),
              )
            : product.stockQuantity <= 0
                ? const Border(
                    left: BorderSide(color: AppColors.error, width: 4),
                  )
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showProductDialog(context, state, product: product),
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Emoji Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      product.emoji ?? _getProductEmoji(product.name),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: AppFontSizes.md,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Stock: ${product.stockQuantity}',
                            style: TextStyle(
                              fontSize: AppFontSizes.sm,
                              color: product.stockQuantity <= 0
                                  ? AppColors.error
                                  : product.isLowStock
                                      ? AppColors.warning
                                      : AppColors.textSecondary,
                              fontWeight: product.stockQuantity <= 0 || product.isLowStock
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          const Text(' • ',
                              style: TextStyle(color: AppColors.textSecondary)),
                          Text(
                            '${AppConstants.currency}${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: AppFontSizes.sm,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                if (product.stockQuantity <= 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    child: const Text(
                      'Out of Stock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.xs,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (product.isLowStock)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    child: const Text(
                      'Low Stock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.xs,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductDialog(BuildContext context, AppState state, {Product? product}) {
    final isEdit = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(
      text: product?.price.toStringAsFixed(0) ?? '',
    );
    final stockController = TextEditingController(
      text: product?.stockQuantity.toString() ?? '',
    );
    final lowStockController = TextEditingController(
      text: product?.lowStockThreshold?.toString() ?? '10',
    );

    String? selectedEmoji = product?.emoji;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEdit ? 'Edit Product' : 'Add Product'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'e.g., Coffee',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price (${AppConstants.currency})',
                    hintText: '0',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity',
                    hintText: '0',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: lowStockController,
                  decoration: const InputDecoration(
                    labelText: 'Low Stock Threshold',
                    hintText: '10',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.lg),
                EmojiPicker(
                  selectedEmoji: selectedEmoji,
                  onEmojiSelected: (emoji) {
                    setState(() {
                      selectedEmoji = emoji;
                    });
                  },
                ),
              ],
              ),
            ),
          ),
          actions: [
          if (isEdit)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Product'),
                    content: Text(
                      'Are you sure you want to delete "${product.name}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await state.deleteProduct(product.id);
                          if (context.mounted) {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} deleted'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Delete'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text) ?? 0;
              final stock = int.tryParse(stockController.text) ?? 0;
              final lowStock = int.tryParse(lowStockController.text);

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a product name'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              if (isEdit) {
                final updatedProduct = product.copyWith(
                  name: name,
                  price: price,
                  stockQuantity: stock,
                  lowStockThreshold: lowStock,
                  emoji: selectedEmoji,
                  updatedAt: DateTime.now(),
                );
                await state.updateProduct(updatedProduct);
              } else {
                final newProduct = Product(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  price: price,
                  stockQuantity: stock,
                  lowStockThreshold: lowStock,
                  emoji: selectedEmoji,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                await state.addProduct(newProduct);
              }

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit
                        ? '$name updated successfully'
                        : '$name added successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
        ),
      ),
    );
  }
}
