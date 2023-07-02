// ignore_for_file: constant_identifier_names

part of example;

void runClient() async {
  PrintMessage.client("Running");
  try {
    final client = await ClientSocket.connect(host: "0.0.0.0", port: 3000);
    handleServerConnection(client);
  } catch (e) {
    PrintMessage.error("Enable to connect to server");
  }
}

void handleServerConnection(Socket client) {
  final subscription = client.on('register', (data) {
    final message = Message.fromJson(data!);
    PrintMessage.server(message.message, server: message.username);
    registerClient(client);
  });

  final registered = client.on('registered', (data) {});

  registered.onData((data) {
    final message = Message.fromJson(data!);
    final user = User(message.message);
    enableMessage(client, user);
    subscription.cancel();
    registered.cancel();
  });
}

void enableMessage(Socket client, User user) async {
  PrintMessage.warning("Now you can send & receive message");
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn(messageIsolate, receivePort.sendPort);
  Stream stream = receivePort.asBroadcastStream();
  final SendPort childSendPort = await stream.first;
  childSendPort.send(IsolateState.Start);

  final sub = client.on('message', (data) {
    childSendPort.send(IsolateState.Pause);
    if (data == null) return;
    final message = Message.fromJson(data);
    if (message.username.toLowerCase() == serverUser) {
      PrintMessage.server(message.message, server: message.username);
    } else {
      PrintMessage.client(message.message, client: message.username);
    }
    childSendPort.send(IsolateState.Restart);
  });

  final sub1 = stream.listen((message) {});

  sub1.onData((message) {
    if (message is String) {
      final userMessage = Message(
        username: user.username,
        message: message.trim(),
      );
      client.send('message', userMessage);
      childSendPort.send(IsolateState.Restart);
    }
  });

  sub1.onDone(() {
    sub1.cancel();
    sub.cancel();
    stream.drain();
  });
}

Future<bool> registerClient(Socket client) async {
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn(usernameIsolate, receivePort.sendPort);
  Stream stream = receivePort.asBroadcastStream();
  final SendPort childSendPort = await stream.first;
  childSendPort.send(IsolateState.Start);

  final sub1 = stream.listen(
    (message) {},
    onDone: () {},
  );
  sub1.onData((message) {
    if (message is String) {
      final user = User(message);
      client.send('register', user);
      childSendPort.send(IsolateState.Stop);
      receivePort.close();
    }
  });
  sub1.onDone(() {
    sub1.cancel();
    stream.drain();
  });
  return false;
}

void usernameIsolate(SendPort sendport) {
  String username() {
    String? username;
    do {
      username = io.stdin.readLineSync(retainNewlines: false);
    } while (username == null || username.isEmpty);
    return username;
  }

  ReceivePort receivePort = ReceivePort();
  sendport.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is! String) return;
    switch (message) {
      case IsolateState.Start:
      case IsolateState.Restart:
        final user = username();
        sendport.send(user);
        break;
      case IsolateState.Pause:
        break;
      case IsolateState.Stop:
        receivePort.close();
        break;
    }
  }, onDone: () {
    Isolate.exit();
  });
}

void messageIsolate(SendPort sendport) {
  ReceivePort receivePort = ReceivePort();
  sendport.send(receivePort.sendPort);

  String getMessage() {
    String? message;
    do {
      message = io.stdin.readLineSync(retainNewlines: false);
    } while (message == null || message.isEmpty);
    return message;
  }

  receivePort.listen((message) {
    if (message is! String) return;
    switch (message) {
      case IsolateState.Start:
      case IsolateState.Restart:
        final message = getMessage();
        sendport.send(message);
        break;
      case IsolateState.Pause:
        break;
      case IsolateState.Stop:
        receivePort.close();
    }
  }, onDone: () {
    Isolate.exit();
  });
}

class IsolateState {
  static const Start = 'start';
  static const Pause = 'pause';
  static const Stop = 'stop';
  static const Restart = 'restart';
}
