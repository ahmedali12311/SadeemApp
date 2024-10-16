import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class User {
  String id;
  String name;
  String email;
  String? imageUrl; // Store the image URL from the backend
  XFile? pickedImage; // Store the picked image from the device
  String? _password;
  String? _phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.pickedImage,
    String? password,
    String? phone,
  })  : _password = password,
        _phone = phone;

  String? get password => _password;
  set password(String? value) => _password = value;

  String? get phone => _phone;
  set phone(String? value) => _phone = value;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: utf8.decode(json['name'].codeUnits),
      email: json['email'] ?? '',
      imageUrl: (json['image'] ?? json['img']) != null
          ? (json['image'] ?? json['img'])
          : null,
      password: json['password'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': pickedImage == null ? imageUrl : pickedImage?.path,
      'password': _password,
      'phone': _phone,
    };
  }
}
