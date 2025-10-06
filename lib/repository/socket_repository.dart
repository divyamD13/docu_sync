import 'package:docu_sync/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final Socket _socket = SocketClient.instance.socket!;

  Socket get socketClient => _socket;

  // Join a document room
  void joinRoom(String documentId) {
    _socket.emit('join', documentId);
    print('Joined room: $documentId');
  }

  // Emit typing/delta changes
  void typing(Map<String, dynamic> data) {
    _socket.emit('typing', data);
  }

  // Emit auto-save
  void autoSave(Map<String, dynamic> data) {
    _socket.emit('save', data);
  }

  // Listen for incoming changes
  void changeListener(Function(Map<String, dynamic>) func) {
    _socket.on('changes', (data) {
      if (data != null) {
        func(Map<String, dynamic>.from(data));
      }
    });
  }
}
