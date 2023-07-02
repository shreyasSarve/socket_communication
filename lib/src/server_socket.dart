part of socket_com;

abstract class ServerSocket {
  late io.ServerSocket _serverSocket;
  late Stream<io.Socket> _broadcastStream;

  static Future<ServerSocket> connect({
    required io.InternetAddress ip,
    required int port,
  }) async {
    final serverSocket = await io.ServerSocket.bind(ip, port);
    final server = _ServerSocket();
    server._setSocket(serverSocket);
    return server;
  }

  void onConnection(void Function(Socket client) run) {
    _broadcastStream.listen((data) {
      final client = _Socket();
      client._setClient(data);
      run(client);
    });
  }

  void _setSocket(io.ServerSocket serverSocket) {
    _serverSocket = serverSocket;
    _broadcastStream = _serverSocket.asBroadcastStream();
  }
}

class _ServerSocket extends ServerSocket {}
