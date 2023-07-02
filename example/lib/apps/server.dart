part of example;

Map<String, Socket> allClient = {};
const serverUser = 'Server';
void runServer() async {
  PrintMessage.server("Running");
  final server =
      await ServerSocket.connect(ip: io.InternetAddress.anyIPv4, port: 3000);
  server.onConnection((client) {
    handleClient(client);
  });
}

List<Socket> clients = [];
void handleClient(Socket client) {
  clients.add(client);
  User? user;
  client.send(
    'register',
    Message(username: "server", message: "Enter username"),
  );

  client.on(
    'register',
    (data) {
      user = onRegister(data, client);
    },
    onDone: () => onClose(user, client),
  );

  client.on(
    'message',
    _onMessage,
    onDone: () => onClose(user, client),
  );
}

void onClose(User? user, Socket client) {
  PrintMessage.info("${user?.username} left");
  if (user != null) {
    allClient.remove(user.username);
  }
  client.destroy();
}

User? onRegister(Map<String, dynamic>? jsonData, Socket client) {
  if (jsonData == null) return null;
  final user = User.fromJson(jsonData);
  if (user.username.toLowerCase() == serverUser.toLowerCase()) {
    client.send(
      'register',
      Message(
        username: serverUser,
        message: 'username is reserver for server',
      ),
    );
    return null;
  }
  if (allClient.containsKey(user.username)) {
    client.send(
      'register',
      Message(
        username: 'Server',
        message: 'username already taken',
      ),
    );
    return null;
  }
  PrintMessage.server("${user.username} is registered", server: serverUser);
  final registerMessage = Message(
    username: serverUser,
    message: user.username,
  );
  allClient[user.username] = client;
  client.send('registered', registerMessage);
  return user;
}

void _onMessage(Map<String, dynamic>? data) {
  if (data == null) return;

  final message = Message.fromJson(data);

  allClient.forEach((key, value) {
    if (key == message.username) return;
    value.send('message', message);
  });
}
