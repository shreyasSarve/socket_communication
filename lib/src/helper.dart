part of socket_com;

class _DataParser {
  static _ConnectionData parseData(Uint8List data) {
    try {
      final stringData = String.fromCharCodes(data);
      final connectionData = _ConnectionData.fromString(stringData);
      return connectionData;
    } catch (e) {
      throw Exception(
        "Data Parsing error : please use DTOs for transferring data over socket",
      );
    }
  }

  // static String? parseDataToString(Uint8List data) {
  //   try {
  //     final connectionData = parseData(data);
  //     return connectionData.data;
  //   } catch (e) {
  //     throw Exception(
  //       "Data Parsing error : please use DTOs for transferring data over socket",
  //     );
  //   }
  // }

  // static Map<String, dynamic>? parseDataToJson(Uint8List data) {
  //   try {
  //     final stringData = parseDataToString(data);
  //     if (stringData == null) return null;
  //     return json.decode(stringData);
  //   } catch (e) {
  //     throw Exception(
  //       "Data Parsing error : please use DTOs for transferring data over socket",
  //     );
  //   }
  // }

  static Map<String, dynamic>? parseDataFromString(String? data) {
    try {
      if (data == null) return null;
      return jsonDecode(data);
    } catch (e) {
      throw Exception(
        "Data Parsing error : please use DTOs for transferring data over socket",
      );
    }
  }
}
