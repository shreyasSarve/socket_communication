part of socket_com;

abstract class Socket extends _SocketWrapper {
  bool _isServerInitialized = false;
  late Job<_ConnectionData> _jobSchedular;
  late io.Socket _socket;
  late StreamSubscription<_ConnectionData> _subscription;
  late Stream<_ConnectionData> _broadcastStream;
  @override
  StreamSubscription<Map<String, dynamic>?> on(
    String on,
    void Function(Map<String, dynamic>? data) onData, {
    void Function(dynamic p1)? onError,
    void Function()? onDone,
  }) {
    assert(!_isServerInitialized, "Client not connected to server");
    return _addListener(onData, on: on, onDone: onDone, onError: onError);
  }

  @override
  void send(String on, DTO data) async {
    _jobSchedular.add(_ConnectionData(on: on, data: data.encode()));
  }

  @override
  StreamSubscription<Map<String, dynamic>?> listen(
    void Function(Map<String, dynamic>? data) onData, {
    Function()? onDone,
    Function? onError,
  }) {
    return _addListener(onData, onDone: onDone, onError: onError);
  }

  void _setClient(io.Socket socket) {
    _socket = socket;
    _broadcastStream = _socket
        .asBroadcastStream()
        .map((event) => _DataParser.parseData(event));
    _subscription = _broadcastStream.listen(
      (event) {},
    );
    _jobSchedular = Job(delay: const Duration(milliseconds: 100));
    _addJobExecuter();
    _isServerInitialized = true;
  }

  void _addJobExecuter() {
    _jobSchedular.addListener((data) {
      _socket.write(data.encode());
    });
  }

  StreamSubscription<Map<String, dynamic>?> _addListener(
      void Function(Map<String, dynamic>? data) run,
      {Function()? onDone,
      Function? onError,
      String? on}) {
    return _broadcastStream
        .where((event) {
          final connectionData = event;
          if (on == null) {
            return true;
          } else if (connectionData.on == on) {
            return true;
          }
          return false;
        })
        .map((event) => _DataParser.parseDataFromString(event.data))
        .listen((event) {
          try {
            run(event);
          } catch (e) {
            onError?.call(e);
          }
        }, onDone: onDone, onError: onError);
  }

  void close() {
    _socket.close();
    _subscription.cancel();
    _broadcastStream.drain();
    _isServerInitialized = false;
    _jobSchedular.dispose();
  }

  void destroy() {
    try {
      _socket.destroy();
      _subscription.cancel();
      _broadcastStream.drain();
      _isServerInitialized = false;
      _jobSchedular.dispose();
    } catch (e) {
      throw Exception("Error occured while destroying socket");
    }
  }

  io.InternetAddress get remoteAddress => _socket.remoteAddress;
  int get remotePort => _socket.remotePort;
}

class _Socket extends Socket {}
