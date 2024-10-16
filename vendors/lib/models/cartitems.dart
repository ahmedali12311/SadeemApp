class CartItem {
  final String id;
  final String name;
  final String img;
  final double price;
  final double discount;
  final int quantity;
  final int totalquantity;

  CartItem(
      {required this.id,
      required this.name,
      required this.img,
      required this.price,
      required this.discount,
      required this.quantity,
      required this.totalquantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['item_id'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      discount:
          json['discount'] != null ? (json['discount'] as num).toDouble() : 0.0,
      quantity: json['quantity'] ?? 0,
      totalquantity: json['total_quantity'] ?? 0,
    );
  }

  CartItem copyWith({
    String? id,
    String? name,
    String? img,
    double? price,
    double? discount,
    int? quantity,
    int? totalquantity,
  }) {
    return CartItem(
        id: id ?? this.id,
        name: name ?? this.name,
        img: img ?? this.img,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        quantity: quantity ?? this.quantity,
        totalquantity: totalquantity ?? this.totalquantity);
  }
}
