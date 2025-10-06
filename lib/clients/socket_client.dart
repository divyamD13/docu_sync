import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:docu_sync/constants.dart';

class SocketClient {
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = io.io(
      host, // your Render backend URL from constants.dart
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    // Connect and debug
    socket!.connect();

    socket!.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    socket!.onConnectError((err) {
      print('Connection error: $err');
    });

    socket!.onError((err) {
      print('Socket error: $err');
    });

    socket!.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
