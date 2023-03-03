// To parse this JSON data, do
//
//     final messages = messagesFromMap(jsonString);

import 'dart:convert';

class Message {
  Message({
    required this.id,
    required this.of,
    required this.from,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String of;
  String from;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        id: json["_id"],
        of: json["of"],
        from: json["from"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "of": of,
        "from": from,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
