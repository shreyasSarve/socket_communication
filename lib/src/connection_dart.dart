part of socket_com;

/// This class is carries data with on which event
///* [on] event
///* [data] data on particular event
class _ConnectionData {
  String on;
  String? data;

  _ConnectionData({required this.on, this.data});

  static _ConnectionData fromJson(Map<String, dynamic> json) {
    try {
      return _ConnectionData(on: json['on'], data: json['data']);
    } catch (e) {
      throw Exception("Error while processing data");
    }
  }

  static _ConnectionData fromString(String data) {
    Map<String, dynamic> jsonData = json.decode(data);
    return fromJson(jsonData);
  }

  Map<String, dynamic> toJson() {
    return {
      "on": on,
      if (data != null) "data": data,
    };
  }

  String encode() {
    return json.encode(toJson());
  }

  @override
  String toString() {
    return "on=$on data=$data";
  }
}
