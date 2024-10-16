import 'dart:convert';

class Vendor {
  final String id;
  final String name;
  final String? imageUrl;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime subscriptionEnd;
  final bool isVisible;

  Vendor({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.subscriptionEnd,
    required this.isVisible,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      name: utf8.decode(json['name'].codeUnits),
      imageUrl: (json['img']) != null ? json['img'] : null,
      description: utf8.decode(json['description'].codeUnits),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      subscriptionEnd: DateTime.parse(json['subscription_end']),
      isVisible: json['is_visible'] ?? false,
    );
  }
}
