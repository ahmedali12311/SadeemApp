import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/vendor.dart';
import '../models/item.dart';
import '../models/table.dart';

class VendorDetailsService {
  final String baseUrl = 'http://localhost:8080';

  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token == null || token.isEmpty) {
      throw Exception('Authorization token is missing or empty.');
    }
    return token;
  }

  Future<Vendor> getVendorDetails(String vendorId) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/vendors/$vendorId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Vendor.fromJson(data['vendor']);
    } else {
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }

  Future<List<Items>> getVendorItems(String vendorId, String searchQuery,
      int currentPage, int itemsPerPage) async {
    final token = await _getAuthToken();
    final url = Uri.parse('$baseUrl/vendor/$vendorId/items'
        '?page=$currentPage&page_size=$itemsPerPage&search=$searchQuery');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['items'] != null) {
        final List<dynamic> items = jsonData['items'];
        return items.map((item) => Items.fromJson(item)).toList();
      } else if (jsonData['item'] != null) {
        final item = jsonData['item'];
        return [Items.fromJson(item)];
      } else {
        return []; // Return an empty list if no items are found
      }
    } else {
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }

  Future<List<Tables>> getVendorTables(String vendorId) async {
    final token = await _getAuthToken();
    final url = Uri.parse('$baseUrl/vendor/$vendorId/tables');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['tables'] != null) {
        final List<dynamic> tables = jsonData['tables'];
        return tables.map((tables) => Tables.fromJson(tables)).toList();
      } else {
        return []; // Return an empty list if no tables are found
      }
    } else {
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }

  Future<void> addToCart(String vendorId, String itemId, int quantity) async {
    final token = await _getAuthToken();
    final url = Uri.parse('$baseUrl/cartitems');
    final queryParameters = {
      'item_id': itemId,
      'quantity': quantity.toString(),
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&'),
    );

    if (response.statusCode > 300 || response.statusCode <= 200) {
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }

  //tables
  Future<void> occupyTable(String vendorId, String tableId) async {
    final token = await _getAuthToken();
    final url =
        Uri.parse('$baseUrl/vendor/$vendorId/tables/$tableId/needs-service');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to occupy the table: ${response.body}');
    }
  }

  // Method to free a table
  Future<void> freeTable(String vendorId, String tableId) async {
    final token = await _getAuthToken();
    final url =
        Uri.parse('$baseUrl/vendor/$vendorId/tables/$tableId/freetable');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }

  Future<Tables?> getUserOccupiedTable() async {
    final token = await _getAuthToken();
    final url = Uri.parse('$baseUrl/usertable');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['tables'] != null) {
        return Tables.fromJson(jsonData['tables']);
      } else {
        return null; // No occupied table found
      }
    } else {
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }

  Future<int> getAvailableQuantity(String itemId) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/items/$itemId/available_quantity'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['available_quantity'];
    } else {
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }
}
