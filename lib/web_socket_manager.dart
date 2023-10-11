import 'dart:async';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  final String url;
  final IOWebSocketChannel channel;
  Timer? keepaliveTimer;

  WebSocketManager(this.url)
      : channel = IOWebSocketChannel.connect(url) {
    // Set up a timer to periodically send keepalive messages
    keepaliveTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      channel.sink.add('Keepalive');
    });

    // Listen for messages from the server
    channel.stream.listen((message) {
      if (message == 'Pong') {
        // Received a Pong response, consider the connection alive
      } else {
        // Handle other messages from the server
      }
    });
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void close() {
    channel.sink.close();
    // Cancel the keepalive timer when closing
    keepaliveTimer?.cancel();
  }
}

