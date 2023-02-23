import 'dart:io';

class Environment {
  static String baseUrl = Platform.isAndroid ? '10.0.2.2' : 'localhost:3000';
  static String socketUrl = 'localhost:3000';
}
