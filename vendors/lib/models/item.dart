import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class Items {
  final String id;
  final String vendorId;
  final String name;
  final double price;
  final double discount;
  final DateTime? discountExpiry;
  final int quantity;
  final String? imageUrl; 
  XFile? pickedImage; 
  final DateTime createdAt;
  final DateTime updatedAt;

  Items({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.price,
    required this.discount,
    this.discountExpiry,
    required this.quantity,
    this.imageUrl,
    this.pickedImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Items.fromJson(Map<String, dynamic> json) {

    return Items(
      id: json['id'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      name: utf8.decode(json['name'].codeUnits,
          allowMalformed: true), 
      price: (json['price'] ?? 0.0).toDouble(), 
      discount: (json['discount'] ?? 0.0).toDouble(),
      discountExpiry: json['discount_expiry'] != null
          ? DateTime.tryParse(
              json['discount_expiry']) 
          : null,
      quantity: json['quantity'] ?? 0, 
      imageUrl: (json['image'] ?? json['img']) != null
          ? (json['image'] ?? json['img'])
          : null,
      createdAt:
          DateTime.parse(json['created_at']), 
      updatedAt:
          DateTime.parse(json['updated_at']), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'name': name,
      'price': price,
      'discount': discount,
      'discount_expiry': discountExpiry?.toIso8601String(),
      'quantity': quantity,
      'image': pickedImage == null ? imageUrl : pickedImage?.path,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
