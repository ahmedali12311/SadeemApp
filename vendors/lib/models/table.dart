import 'dart:convert';

class Tables {
  final String id;
  final String vendorId;
  final String name;
  final String? customerId;
  final bool isAvailable;
  final bool isNeedsServices;

  Tables({
    required this.id,
    required this.vendorId,
    required this.name,
    this.customerId,
    required this.isAvailable,
    required this.isNeedsServices,
  });

  factory Tables.fromJson(Map<String, dynamic> json) {
    return Tables(
      id: json['id'],
      vendorId: json['vendor_id'],
      name: utf8.decode(json['name'].codeUnits),
      customerId: json['customer_id'],
      isAvailable: json['is_available'],
      isNeedsServices: json['is_needs_service'],
    );
  }
}
