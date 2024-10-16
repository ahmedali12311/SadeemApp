// lib/models/cart_model.dart

import 'dart:convert';

class Cart {
  final String id;
  final double totalPrice;
  final int quantity;
  final String vendorID;
  final String vendorName;
  final String Description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.totalPrice,
    required this.quantity,
    required this.vendorID,
    required this.vendorName,
    required this.Description,
    required this.createdAt,
    required this.updatedAt,
  });
  static String decodeArabic(String encodedStr) {
    return utf8.decode(encodedStr.codeUnits);
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json["cart"]["cart"]['id'] ??
          '', // default to empty string if 'ID' is null
      totalPrice: json["cart"]["cart"]['total_price'] != null
          ? (json["cart"]["cart"]['total_price'] as num).toDouble()
          : 0.0, // default to 0.0 if 'Total_Price' is null
      quantity: json["cart"]["cart"]['quantity'] ??
          0, // default to 0 if 'Quantity' is null
      vendorID: json["cart"]["cart"]['vendor_id'] ?? "",
      Description: decodeArabic(json["cart"]['cart']['description'] ?? ''),

      vendorName: decodeArabic(json["cart"]['vendorname'] ?? ''),
      // default to empty string if 'VendorID' is null
      createdAt: json["cart"]["cart"]['createdAt'] != null
          ? DateTime.parse(json["cart"]["cart"]['createdAt'])
          : DateTime.now(), // default to current date if 'createdAt' is null
      updatedAt: json["cart"]["cart"]['updatedAt'] != null
          ? DateTime.parse(json["cart"]["cart"]['updatedAt'])
          : DateTime.now(), // default to current date if 'updatedAt' is null
    );
  }
  // Method to convert Cart instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Total_Price': totalPrice,
      'Quantity': quantity,
      'VendorID': vendorID,
      'Description': Description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
