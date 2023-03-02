// To parse this JSON data, do
//
//     final friend = friendFromMap(jsonString);

import 'dart:convert';

class Friend {
  Friend(
      {required this.id,
      required this.fullName,
      required this.email,
      this.online = false});

  String id;
  String fullName;
  String email;
  bool? online;

  factory Friend.fromJson(String str) => Friend.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Friend.fromMap(Map<String, dynamic> json) => Friend(
        id: json["_id"],
        fullName: json["fullName"],
        email: json["email"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "fullName": fullName,
        "email": email,
      };
}
