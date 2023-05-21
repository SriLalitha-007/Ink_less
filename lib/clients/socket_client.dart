import 'package:flutter_googledocs_clone/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    print(host);
    socket = io.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    // socket = io.io(host);
    // socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
