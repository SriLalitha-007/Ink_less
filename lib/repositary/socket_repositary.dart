import 'package:flutter_googledocs_clone/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepositary {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void joinRoom(String documentId) {
    print('asdasdasdasdasdasdasdasd');
    _socketClient.emit('join', documentId);
    print(_socketClient.connected);
  }
}
