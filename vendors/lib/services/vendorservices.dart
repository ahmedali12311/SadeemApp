// lib/services/vendor_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vendor.dart';
import '../models/user.dart';

class VendorService {
  Future<VendorResult> getVendors(
      int page, int pageSize, String sortOrder, String search) async {
    final itemsPerPage = pageSize;
    final url = Uri.parse(
        'http://localhost:8080/vendors?page=$page&pageSize=$itemsPerPage&sort=$sortOrder&search=$search');

    // Retrieve the token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Vendors'] != null) {
        final vendors = (data['Vendors'] as List)
            .map((vendor) => Vendor.fromJson(vendor))
            .toList();
        return VendorResult(vendors: vendors, totalPages: data['TotalCount']);
      } else {
        return VendorResult(vendors: [], totalPages: 0);
      }
    } else {
      throw Exception('Failed to load vendors');
    }
  }

  // New method to fetch user profile
  Future<User?> getUserProfile() async {
    final url = Uri.parse('http://localhost:8080/me');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final userInfo = jsonData['me']['user_info'];
      return User.fromJson({
        'id': userInfo['id'],
        'name': userInfo['name'] ?? '',
        'email': userInfo['email'] ?? '',
        'phone': userInfo['phone'],
        'image': userInfo['img'],
      });
    } else {
      print(
          'Failed to load user profile: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load user profile');
    }
  }
}

class VendorResult {
  final List<Vendor> vendors;
  final int totalPages;

  VendorResult({required this.vendors, required this.totalPages});
}
