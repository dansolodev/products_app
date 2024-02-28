import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = '';
  final String _firebaseToken = '';

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
      //decodesResp['idToken'];
      return null;
    } else {
      return decodesResp['error']['message'];
    }
  }
}
