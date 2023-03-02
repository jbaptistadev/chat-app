import 'dart:io';

class Environment {
  static String baseUrl = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  static String socketUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000/socket'
      : 'http://localhost:3000/socket';
}
