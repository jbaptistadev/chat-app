import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/models.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Friend userFrom;

  Future<List<Message>> getChat(String userID) async {
    try {
      final token = await AuthService.getToken();
      final url = Uri(
        scheme: 'http',
        host: Environment.baseUrl,
        port: 3000,
        path: '/api/chat/room/$userID',
      );
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        print(errorResponse);
      }
      final responseDecoded = jsonDecode(response.body);

      final messageList = List.generate(responseDecoded.length, (index) {
        final message = responseDecoded[index];

        return (Message.fromMap(message));
      });

      return messageList;
    } catch (e) {
      print(e);

      return [];
    }
  }
}
