import 'dart:convert';

import 'package:socket_com/socket_com.dart' show DTO;

class Message extends DTO {
  String username;
  String message;

  Message({required this.username, required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(username: json['username'], message: json['message']);
  }
  factory Message.fromString(String message) {
    Map<String, dynamic> jsonMessage = jsonDecode(message);
    return Message.fromJson(jsonMessage);
  }
  @override
  Map<String, dynamic> toJson() {
    return {"username": username, "message": message};
  }

  @override
  String encode() {
    return json.encode(toJson());
  }
}
