part of socket_com;

abstract class _SocketWrapper {
  StreamSubscription<Map<String, dynamic>?> on(
    String on,
    void Function(Map<String, dynamic>?) onData, {
    void Function(dynamic)? onError,
    void Function()? onDone,
  });
  void send(String on, DTO data);
  StreamSubscription<Map<String, dynamic>?> listen(
      Function(Map<String, dynamic>? data) onData);
}
