import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendors/models/cart.dart';
import 'package:vendors/models/cartitems.dart';

class CartService {
  final String baseUrl = "http://localhost:8080";
  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token == null || token.isEmpty) {
      throw Exception('Authorization token is missing or empty.');
    }
    return token;
  }

  Future<void> updateCartItem(String id, CartItem updatedItem) async {
    final token = await _getAuthToken();
    String url = '$baseUrl/cartitems/$id';
    final response = await http.put(
      Uri.parse('$url'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'item_id': id,
        'quantity':
            updatedItem.quantity.toString(), // Ensure quantity is a string
      },
    );

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      throw responseBody['error'] ?? 'An unknown error occurred';
    }
  }

  CartService();
  Future<List<Cart>> fetchCart() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/carts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      dynamic cartJson = jsonDecode(response.body);
      if (cartJson is List) {
        return cartJson
            .map((json) => Cart.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (cartJson is Map) {
        if (cartJson.keys.every((key) => key is String)) {
          return [Cart.fromJson(cartJson as Map<String, dynamic>)];
        } else {
          throw Exception('Invalid JSON response: keys are not strings');
        }
      } else {
        throw Exception('Invalid JSON response');
      }
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<List<CartItem>> fetchCartItems() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/cartitems'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      dynamic cartItemsJson = jsonDecode(response.body);
      if (cartItemsJson is Map && cartItemsJson['cart'] is List) {
        List<CartItem> cartItems = cartItemsJson['cart']
            .map((json) => CartItem.fromJson(json as Map<String, dynamic>))
            .toList()
            .cast<CartItem>();
        return cartItems;
      } else {
        throw Exception('Invalid JSON response');
      }
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<void> deleteCart(String id) async {
    final token = await _getAuthToken();
    String url = '$baseUrl/cartitems/$id';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      throw responseBody['error'] ?? 'An unknown error occurred';
    }
  }

  Future<void> updateCart(String id, String description) async {
    final token = await _getAuthToken();
    String url = '$baseUrl/carts/$id';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'description': description,
      },
    );

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      throw responseBody['error'] ?? 'An unknown error occurred';
    }
  }

  Future<void> checkoutCart() async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$baseUrl/checkout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      throw responseBody['error'] ?? 'An unknown error occurred';
    }
  }
}
