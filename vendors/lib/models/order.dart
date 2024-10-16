// OrderDetails Model
import 'dart:convert';

class OrderDetails {
  final String id;
  final double totalOrderCost;
  final String vendorName;
  final String vendorId;
  final String userName;
  final String customerId;
  final List<String> itemNames;
  final List<double> itemPrices;
  final List<int> itemQuantities;
  final String status;
  final String tableId;
  final String tableName;
  final String description;
  final String customerPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderDetails({
    required this.id,
    required this.totalOrderCost,
    required this.vendorName,
    required this.vendorId,
    required this.userName,
    required this.customerId,
    required this.itemNames,
    required this.itemPrices,
    required this.itemQuantities,
    required this.status,
    required this.tableId,
    required this.tableName,
    required this.description,
    required this.customerPhone,
    required this.createdAt,
    required this.updatedAt,
  });
  static String decodeArabic(String encodedStr) {
    return utf8.decode(encodedStr.codeUnits);
  }

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'] as String? ?? '', // Default to an empty string if null
      totalOrderCost:
          json['total_order_cost'] as double? ?? 0.0, // Default to 0.0 if null
      vendorName: decodeArabic(
          json['vendor_name'] as String? ?? 'Unknown'), // Default value if null
      vendorId: json['vendor_id'] as String? ?? '',
      userName: decodeArabic(json['user_name'] as String? ?? 'Anonymous'),
      customerId: json['customer_id'] as String? ?? '',
      itemNames: List<String>.from(
          json['item_names'].map((item) => decodeArabic(item)) ?? []),
      itemPrices: List<double>.from(json['item_prices'] ?? []),
      itemQuantities: List<int>.from(json['item_quantities'] ?? []),
      status: json['status'] as String? ?? 'Unknown',
      tableId: json['table_id'] as String? ?? '',
      tableName: decodeArabic(json['table_name'] as String? ?? ''),
      description: json['description'] as String? ?? '',
      customerPhone: json['CustomerPhone'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ??
          DateTime.now().toIso8601String()), // Default to now if null
      updatedAt: DateTime.parse(
          json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

// Order Model
class Order {
  final String id;
  final double totalOrderCost;
  final String customerId;
  final String vendorId;
  final String status;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.totalOrderCost,
    required this.customerId,
    required this.vendorId,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['id']),
      totalOrderCost: json['total_order_cost'],
      customerId: (json['customer_id']),
      vendorId: (json['vendor_id']),
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
