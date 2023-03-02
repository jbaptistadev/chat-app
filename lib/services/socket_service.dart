import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;
import 'package:http/http.dart' as http;
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/services/services.dart';

enum ServerStatus { online, offLine, connectig }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connectig;
  List<Friend> _onlineUsers = [];
  List<Friend> _friendsList = [];
  late i_o.Socket _socket = i_o.io(
    Environment.socketUrl,
  );

  SocketService() {
    getFriends();
  }

  ServerStatus get serverStatus => _serverStatus;
  i_o.Socket get socket => _socket;

  List<Friend> get onlineUsers => _onlineUsers;
  set onlineUsers(List<Friend> value) {
    _onlineUsers = value;
    notifyListeners();
  }

  List<Friend> get friendsList => _friendsList;
  set friendsList(List<Friend> value) {
    _friendsList = value;
    notifyListeners();
  }

  void connect() async {
    final token = await AuthService.getToken();
    _socket = i_o.io(
        Environment.socketUrl,
        i_o.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'authorization': token}) // optional
            .build());

    _socket.connect();

    _socket.on('connect', (data) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.on('clients-updated', (data) {
      onlineUsers = List.generate(
          data.length,
          (int index) => Friend(
                id: data[index]['_id'],
                fullName: data[index]['fullName'],
                email: data[index]['email'],
              ));
    });

    _socket.on('disconnect', (data) {
      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }

  Future<void> getFriends() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri(
        scheme: 'http',
        host: Environment.baseUrl,
        port: 3000,
        path: '/api/friends',
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

      friendsList = List.generate(
          responseDecoded.length,
          (int index) => Friend(
                id: responseDecoded[index]['_id'],
                fullName: responseDecoded[index]['fullName'],
                email: responseDecoded[index]['email'],
              ));
    } catch (e) {
      print(e);
    }
  }
}
