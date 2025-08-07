import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:verify/core/constants.dart';

class ApiService {
  static const String apiPrefix = '/api';
  static const String registerPath = '$apiPrefix/signup';

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String address,
    File profileImage,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$registerPath'),
      );
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['address'] = address;
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          profileImage.path,
          filename: path.basename(profileImage.path),
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception(
          'Registration failed with status ${response.statusCode}: $responseBody',
        );
      }

      var jsonResponse = jsonDecode(responseBody);
      if (jsonResponse is! Map<String, dynamic>) {
        throw Exception('Invalid response format: $responseBody');
      }

      return jsonResponse;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl$apiPrefix/verify-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'otp': otp},
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<Map<String, dynamic>> uploadDocument(
    String email,
    File documentImage,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$apiPrefix/upload-document'),
      );
      request.fields['email'] = email;
      request.files.add(
        await http.MultipartFile.fromPath(
          'document_image',
          documentImage.path,
          filename: path.basename(documentImage.path),
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      return jsonDecode(responseBody);
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<Map<String, dynamic>> uploadSelfie(
    String email,
    File selfieImage,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$apiPrefix/upload-selfie'),
      );
      request.fields['email'] = email;
      request.files.add(
        await http.MultipartFile.fromPath(
          'selfie_image',
          selfieImage.path,
          filename: path.basename(selfieImage.path),
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception(
          'Selfie upload failed with status ${response.statusCode}: $responseBody',
        );
      }

      var jsonResponse = jsonDecode(responseBody);
      if (jsonResponse is! Map<String, dynamic>) {
        throw Exception('Invalid response format: $responseBody');
      }

      return jsonResponse;
    } catch (e) {
      throw Exception('Failed to upload selfie: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl$apiPrefix/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'password': password},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Login failed with status ${response.statusCode}: ${response.body}',
        );
      }

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is! Map<String, dynamic>) {
        throw Exception('Invalid response format: ${response.body}');
      }

      return jsonResponse;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAccount(String email) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl$apiPrefix/delete-account'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Account deletion failed with status ${response.statusCode}: ${response.body}',
        );
      }

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is! Map<String, dynamic>) {
        throw Exception('Invalid response format: ${response.body}');
      }

      return jsonResponse;
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  Future<Map<String, dynamic>> changePassword(
    String email,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl$apiPrefix/change-password'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Password change failed with status ${response.statusCode}: ${response.body}',
        );
      }

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is! Map<String, dynamic>) {
        throw Exception('Invalid response format: ${response.body}');
      }

      return jsonResponse;
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}
