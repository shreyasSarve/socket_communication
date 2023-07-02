library example;

import 'dart:io' as io;
import 'dart:isolate';

import 'package:socket_com/socket_com.dart';

import 'models/data.dart';
import 'models/message.dart';
import 'models/print.dart';

part 'apps/client.dart';
part 'apps/server.dart';

class ENV {
  static const client = "client";
  static const server = "server";
}

void main(List<String> arguments) async {
  const env = String.fromEnvironment("env");
  if (env == ENV.server) {
    runServer();
  } else {
    runClient();
  }
}
