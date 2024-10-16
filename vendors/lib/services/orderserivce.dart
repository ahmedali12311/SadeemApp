import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://localhost:8080';
  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token == null || token.isEmpty) {
      throw Exception('Authorization token is missing or empty.');
    }
    return token;
  }

  // Fetch current user details including role
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(Uri.parse('$baseUrl/me'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<OrderDetails>> getUserOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String url = '$baseUrl/orders';
    String? token = prefs.getString('authToken');

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['orders']; // Adjust this line

      return data.map((order) => OrderDetails.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // Fetch vendor's orders
  Future<List<OrderDetails>> getVendorOrders(String vendorId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/vendor/$vendorId/orders'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((order) => OrderDetails.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load vendor orders');
    }
  }
}
