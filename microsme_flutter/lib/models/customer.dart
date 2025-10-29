class Customer {
  final String id;
  final String phoneNumber;
  final String? name;
  final int points;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.phoneNumber,
    this.name,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayName => name ?? phoneNumber;

  bool hasEnoughPoints(int requiredPoints) => points >= requiredPoints;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'name': name,
      'points': points,
      'total_spent': 0.0, // Deprecated: calculated dynamically now
      'sales_count': 0, // Deprecated: calculated dynamically now
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      phoneNumber: map['phone_number'],
      name: map['name'],
      points: map['points'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  Customer copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    int? points,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
