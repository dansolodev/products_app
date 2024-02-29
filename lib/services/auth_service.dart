import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = '';
  final String _firebaseToken = '';

  // Create storage
  final storage = const FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodesResp = json.decode(response.body);
    if (decodesResp.containsKey('idToken')) {
      // saven token
      await storage.write(key: 'token', value: decodesResp['idToken']);
      return null;
    } else {
      return decodesResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodesResp = json.decode(response.body);
    if (decodesResp.containsKey('idToken')) {
      // saven token
      await storage.write(key: 'token', value: decodesResp['idToken']);
      return null;
    } else {
      return decodesResp['error']['message'];
    }
  }

  Future logout() async {
    // Delete value
    await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    // Read value
    return await storage.read(key: 'token') ?? '';
  }
}
