class Product {
  final String id;
  final String name;
  final double price;
  final int stockQuantity;
  final int? lowStockThreshold;
  final String? emoji;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stockQuantity,
    this.lowStockThreshold,
    this.emoji,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isLowStock {
    if (lowStockThreshold == null) return false;
    return stockQuantity <= lowStockThreshold!;
  }

  bool get isInStock => stockQuantity > 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock_quantity': stockQuantity,
      'low_stock_threshold': lowStockThreshold,
      'emoji': emoji,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      stockQuantity: map['stock_quantity'],
      lowStockThreshold: map['low_stock_threshold'],
      emoji: map['emoji'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? stockQuantity,
    int? lowStockThreshold,
    String? emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
