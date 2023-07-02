part of socket_com;

/// Abstract class used for accessing connect method to
/// connect to server
abstract class ClientSocket {
  /// Establish connection with server [host] at port [port]
  static Future<Socket> connect(
      {required String host, required int port}) async {
    final socket = await io.Socket.connect(host, port);
    final client = _Socket();
    client._setClient(socket);
    return client;
  }
}
