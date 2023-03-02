import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  late User user;
  bool _isAuthenticating = false;

  final _storage = const FlutterSecureStorage();

  bool get isAuthenticating => _isAuthenticating;
  set isAuthenticating(bool value) {
    _isAuthenticating = value;
    notifyListeners();
  }

// Getters of token static way
  static Future<String> getToken() async {
    const staticStorage = FlutterSecureStorage();
    final token = await staticStorage.read(key: 'token');

    return token ?? '';
  }

  static Future<void> removeToken() async {
    const staticStorage = FlutterSecureStorage();
    await staticStorage.delete(key: 'token');
  }

  Future login(String email, String password) async {
    final data = {'email': email, 'password': password};
    isAuthenticating = true;
    try {
      final url = Uri(
        scheme: 'http',
        host: Environment.baseUrl,
        port: 3000,
        path: '/api/auth/signIn',
      );
      final response = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 400 || response.statusCode == 401) {
        final errorResponse = jsonDecode(response.body);
        return errorResponse['message'][0].toString();
      }

      final userResponse = User.fromJson(response.body);

      user = userResponse;
      await _setToken(user.token);

      return true;
    } catch (e) {
      return false;
    } finally {
      isAuthenticating = false;
    }
  }

  Future register(String name, String email, String password) async {
    final data = {'fullName': name, 'email': email, 'password': password};
    isAuthenticating = true;
    try {
      final url = Uri(
        scheme: 'http',
        host: Environment.baseUrl,
        port: 3000,
        path: '/api/auth/signUp',
      );
      final response = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 400) {
        final errorResponse = jsonDecode(response.body);
        return errorResponse['message'][0].toString();
      }

      final userResponse = User.fromJson(response.body);

      user = userResponse;

      await _setToken(user.token);

      return true;
    } catch (e) {
      return false;
    } finally {
      isAuthenticating = false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: 'token');

      final url = Uri(
        scheme: 'http',
        host: Environment.baseUrl,
        port: 3000,
        path: '/api/auth/check',
      );
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        logOut();
        return false;
      }

      final userResponse = User.fromJson(response.body);
      user = userResponse;
      //await _setToken(userResponse.token); bug in backend

      return true;
    } catch (e) {
      logOut();

      return false;
    }
  }

  Future<void> _setToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    await _storage.deleteAll();
  }
}
