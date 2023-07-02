library dto;

import 'dart:convert';

/// This abstract class is helpful for data transmission over socket connections
/// remember to decode the data as you have encoded from
abstract class DTO {
  Map<String, dynamic> toJson();
  String encode() {
    return jsonEncode(toJson());
  }
}
