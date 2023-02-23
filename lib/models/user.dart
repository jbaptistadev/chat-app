// To parse this JSON data, do
//
//     final User = UserFromMap(jsonString);

import 'dart:convert';

class User {
  User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.token,
      this.online = false});

  String id;
  String fullName;
  String email;
  String token;
  bool online;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["_id"],
        fullName: json["fullName"],
        email: json["email"],
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "fullName": fullName,
        "email": email,
        "token": token,
      };
}
