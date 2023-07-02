// ignore_for_file: avoid_print

import 'dart:io';

class PrintMessage {
  static void server(Object? message, {String? server}) {
    print("\n");
    server = server ?? "server";
    stdout.write('\x1B[43m$server\x1B[0m');
    stdout.write("\x1B[47m::\x1B[0m");
    stdout.write(" ");
    print('\x1B[33m$message\x1B[0m');
  }

  static void error(Object? message) {
    print('\x1B[41m$message\x1B[0m');
  }

  static void client(Object? message, {String? client}) {
    client = client ?? "client";
    stdout.write('\x1B[42m$client\x1B[0m');
    stdout.write("\x1B[47m::\x1B[0m");
    stdout.write(" ");
    print('\x1B[32m$message\x1B[0m');
    print("");
  }

  static void info(Object? message) {
    print('\x1B[46m$message\x1B[0m');
  }

  static void warning(Object? message) {
    print('\x1B[44m$message\x1B[0m');
  }
}
