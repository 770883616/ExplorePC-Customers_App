import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  final String _url =
      'ws://192.168.0.28:8000/ws/notifications'; // استبدل بمسار WebSocket الخاص بك

  void connect(int userId) {
    _channel = WebSocketChannel.connect(
      Uri.parse('$_url?user_id=$userId'),
    );
  }

  Stream<dynamic> get stream => _channel?.stream ?? const Stream.empty();

  void disconnect() {
    _channel?.sink.close();
  }
}
