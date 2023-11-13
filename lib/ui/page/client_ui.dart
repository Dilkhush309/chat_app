import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ClientUI extends StatefulWidget {
  const ClientUI({super.key});

  @override
  State<ClientUI> createState() => _ClientUIState();
}

class _ClientUIState extends State<ClientUI> {
  final String serverUrl1 = 'ws://133.242.143.29:8443';
  final String serverUrl2 = 'ws://133.242.143.29:80';
  late IOWebSocketChannel _channel = IOWebSocketChannel.connect(serverUrl1);

  bool server1Selected = true;
  bool server2Selected = false;
  String selectedServer = '';

  // Function to handle server 1 checkbox tap
  void handleServer1Tap() {
    setState(() {
      server1Selected = !server1Selected;
      server2Selected = false;
    });
  }

  // Function to handle server 2 checkbox tap
  void handleServer2Tap() {
    setState(() {
      server2Selected = !server2Selected;
      server1Selected = false;
    });
  }

  // Function to handle button press
  void handleConnectButton() {
    _channel = IOWebSocketChannel.connect(serverUrl1);
    void performWebSocketHandshake() {
      // Close the existing WebSocket connection
      _channel.sink.close();

      setState(() {
        if (server1Selected) {
          // Connect to server 1
          selectedServer = 'Server 1 is selected';

          // Create a new WebSocket connection
          _channel = IOWebSocketChannel.connect(serverUrl1);
        } else if (server2Selected) {
          // Connect to server 2
          selectedServer = 'Server 2 is selected';

          // Create a new WebSocket connection
          _channel = IOWebSocketChannel.connect(serverUrl2);
        } else {
          selectedServer = 'No server selected';
        }
      });
    }

    // Set up a listener for WebSocket messages
    _channel.stream.listen(
      (message) {
        // Handle WebSocket messages here
        final data = message.toString();
        print('Received: $data');

        // parsing the response as JSON if needed
        final response = jsonDecode(data);
        if (response["data-type"] == "authentication" &&
            response["response-result"] == 200) {
          print('Authentication successful');
          print(response);
        } else {
          print('Authentication failed');
        }
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
    // Initialize the WebSocket handshake when the button is cl
    performWebSocketHandshake();
  }

  void _sendAuthenticationRequest() {
    final authenticationMessage = {
      "data-type": "authentication",
      "authentication-code":
          "5e73f1b58a4ab94d54cd8ed93cd55ff46fdd80d16e0f8cf86b87d4968ee655b7"
    };
    _channel.sink.add(json.encode(authenticationMessage));
  }

  void _disasterInformationRequest() {
    final disasterInformation = {
      "data-type": "send-message",
      "authentication-code": "5e73f1b58a4ab94d54cd8ed93cd55ff46fdd80d16e0f8cf86b87d4968ee655b7",
      "distribution-id": "ieam_e3_2",
      "response-result": 200
    };
    _channel.sink.add(json.encode(disasterInformation));
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          'Client UI',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                shape: const CircleBorder(),
                value: server1Selected,
                onChanged: (bool? value) {
                  handleServer1Tap();
                },
              ),
              const Text(
                "Server 1",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                shape: const CircleBorder(),
                value: server2Selected,
                onChanged: (bool? value) {
                  handleServer2Tap();
                },
              ),
              const Text(
                "Server 2",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          const Divider(
            height: 20.0,
            color: Colors.black,
            thickness: 2.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 16)),
              // onPressed: _connectToWebSocket,
              onPressed: handleConnectButton,
              child: const Text('Connect Server Button'),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(selectedServer),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Log Area",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: _channel.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.hasData) {
                            final response = snapshot.data;
                            // Handle the response data as needed
                            return Text('Received: $response');
                          }

                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 16)),
            onPressed: _sendAuthenticationRequest,
            child: const Text('Authentication Button'),
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 16)),
            onPressed: _disasterInformationRequest,
            child: const Text('Disaster Information Button'),
          ),
        ],
      ),
    );
  }
}
