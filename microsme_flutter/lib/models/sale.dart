class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      productName: map['productName'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}

enum PaymentMethod {
  cash,
  transfer,
  qr,
  redemption,
}

class Sale {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discountAmount;
  final double total;
  final PaymentMethod paymentMethod;
  final String? customerId;
  final String? customerName;
  final int? pointsAwarded;
  final int? pointsRedeemed;
  final DateTime createdAt;

  Sale({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.paymentMethod,
    this.customerId,
    this.customerName,
    this.pointsAwarded,
    this.pointsRedeemed,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((i) => i.toMap()).toList(),
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'total': total,
      'payment_method': paymentMethod.name,
      'customer_id': customerId,
      'customer_name': customerName,
      'points_awarded': pointsAwarded,
      'points_redeemed': pointsRedeemed,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      items: (map['items'] as List).map((i) => CartItem.fromMap(i)).toList(),
      subtotal: map['subtotal'],
      discountAmount: map['discount_amount'],
      total: map['total'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == map['payment_method'],
      ),
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      pointsAwarded: map['points_awarded'],
      pointsRedeemed: map['points_redeemed'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}
