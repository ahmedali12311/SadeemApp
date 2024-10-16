import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ProfileService {
  final String baseUrl = 'http://localhost:8080';

  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token == null || token.isEmpty) {
      throw Exception('Authorization token is missing or empty.');
    }
    return token;
  }

  Future<User> getUserData() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
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
      final jsonData = jsonDecode(response.body);
      throw jsonData['error'];
    }
  }

  Future<void> updateUserData(String userId, String name, String email,
      String password, String phone, XFile? imageFile) async {
    final token = await _getAuthToken();
    var request =
        http.MultipartRequest('PUT', Uri.parse('$baseUrl/users/$userId'));
    request.headers['Authorization'] = 'Bearer $token';

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('img', imageFile.path));
    }
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['phone'] = phone;

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update user data: ${await response.stream.bytesToString()}');
    }
  }

  Future<void> uploadImage(XFile imageFile) async {
    // Assuming you have a method to upload the image to your backend
    // Convert XFile to File
    File file = File(imageFile.path);

    // Use your preferred method to upload the file
    // For example, using http package
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://localhost:8080/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image');
    }
  }
}
