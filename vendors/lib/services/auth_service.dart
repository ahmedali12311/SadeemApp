import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';

class AuthService {
  Future<bool> isValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) return false;

    final uri = Uri.parse(
        'http://localhost:8080/me'); // or any other protected endpoint
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    return response.statusCode == 200;
  }

  Future<Response> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    XFile? imageFile,
  }) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      return Response.error({'error': 'All fields are required.'});
    }

    print("Payload: {name: $name, email: $email, phone: $phone}");

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8080/signup'),
      );

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['password'] = password;

      if (imageFile != null) {
        print("Image path: ${imageFile.path}");
        var file = File(imageFile.path);
        print("File exists: ${await file.exists()}");
        print("File size: ${await file.length()}");
        var multipartFile = await http.MultipartFile.fromPath('img', file.path);
        print("Multipart file created: $multipartFile");
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Response.success(json.decode(responseBody.body));
      } else {
        print("Sign Up Error: ${response.statusCode} - ${responseBody.body}");
        return Response.error(json.decode(responseBody.body));
      }
    } catch (error) {
      print("Sign Up Exception: $error");
      return Response.error({'error': 'An error occurred'});
    }
  }

  Future<Response> signIn({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('http://localhost:8080/signin');

    try {
      final response = await http.post(
        uri,
        body: {
          'email': email,
          'password': password,
        },
      );
      print("Sign In Response: ${response.body}");

      if (response.statusCode != 200) {
        return Response.error({'error': 'Invalid email or password'});
      }

      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      // Store the token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);

      return Response.success(responseData);
    } catch (error) {
      print("Sign In Error: $error");
      return Response.error({'error': 'An error occurred'});
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}

class Response {
  final bool hasError;
  final dynamic data;
  final dynamic error;

  // Named constructor for successful responses
  Response.success(this.data)
      : hasError = false,
        error = null;

  // Named constructor for error responses
  Response.error(this.error)
      : hasError = true,
        data = null;
}
