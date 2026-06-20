import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.101:5000/api';
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Send OTP
  Future<Map<String, dynamic>> sendOtp(String phoneNumber, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phoneNumber': phoneNumber, 'role': role}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Failed to send OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Verify OTP and create user with full profile data
  Future<Map<String, dynamic>> verifyOtp(
    String phoneNumber,
    String otp,
    String role, {
    Map<String, dynamic>? userData, // ADDED: Receive user profile data
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'phoneNumber': phoneNumber,
        'otp': otp,
        'role': role,
      };

      // Add user profile data if provided (for registration)
      if (userData != null) {
        requestBody['userData'] = userData;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save JWT token and user data
        if (data['token'] != null) {
          await _storage.write(key: _tokenKey, value: data['token']);
        }
        if (data['user'] != null) {
          await _storage.write(key: _userKey, value: json.encode(data['user']));
        }

        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Invalid OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Rest of the methods remain the same...
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: _userKey);
    if (userData != null) {
      return json.decode(userData);
    }
    return null;
  }

  Future<String?> getUserRole() async {
    final userData = await getUserData();
    return userData?['role'];
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  Future<String?> autoLogin() async {
    final isLoggedIn = await this.isLoggedIn();
    if (!isLoggedIn) return null;

    final role = await getUserRole();
    return role;
  }
}
