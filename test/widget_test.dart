// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:chat_app/main.dart';
// import 'package:web_socket_channel/io.dart';

// void main() {
//   testWidgets('Connect to Server 2, Authenticate, and Receive Disaster Information', (WidgetTester tester) async {

//      // Start your WebSocket server
//     final server = await startWebSocketServer();
//     await tester.pumpWidget(const MyApp());

//     // Connect to the WebSocket server using a WebSocket channel
//     final channel = IOWebSocketChannel.connect('ws://localhost:${server.port}');

//      // Send a message to the server
//     channel.sink.add('Hello, WebSocket Server!');

//     // Wait for the server to process the message
//     await Future.delayed(Duration(seconds: 1));

//     // Assert that the server received the message
//     expect(server.lastMessage, 'Hello, WebSocket Server!');

//     // Close the WebSocket channel
//     channel.sink.close();

//     // Stop the WebSocket server
//     await server.close();

   

//     // Verify initial state
//     expect(find.text('Server 1'), findsOneWidget, reason: 'Initial state not as expected');
//     expect(find.text('Server 2 is selected'), findsNothing, reason: 'Initial state not as expected');

//     // Tap Server 2 checkbox
//     await tester.tap(find.text('Server 2'));
//     await tester.pump();

//     // Verify that Server 2 is selected
//     expect(find.text('Server 2 is selected'), findsNothing, reason: 'Server 1 not selected');
//     expect(find.text('Server 2'), findsOneWidget, reason: 'Server 1 not selected');

//     // Tap the Connect Server Button
//     await tester.tap(find.byKey(const Key('connectServerButton')));
//     await tester.pump();

//     // Check for successful connection or an error message
//     if (find.text('Connected to Server 2', skipOffstage: false).evaluate().isEmpty) {
//       // Connection failed, assert an error
//       fail('Failed to connect to Server 2');
//     }

//     // Verify the connected state
//     expect(find.text('Connected to Server 2'), findsOneWidget, reason: 'Connection to Server 2 failed');

//     // Tap the Authentication Button
//     await tester.tap(find.byKey(const Key('authenticationButton')));
//     await tester.pump();

//     // Check for successful authentication or an error message
//     if (find.text('Authentication successful', skipOffstage: false).evaluate().isEmpty) {
//       // Authentication failed, assert an error
//       fail('Authentication failed');
//     }

//     // Verify the authentication state
//     expect(find.text('Authentication successful'), findsOneWidget, reason: 'Authentication failed');

//     // Tap the Disaster Information Button
//     await tester.tap(find.byKey(const Key('disasterInformationButton')));
//     await tester.pump();

//     // Check for successful receipt of disaster information or an error message
//     if (find.text('Disaster Information Screen', skipOffstage: false).evaluate().isEmpty) {
//       // Failed to receive disaster information, assert an error
//       fail('Failed to receive disaster information');
//     }

//     // Verify the navigation to disaster information
//     expect(find.text('Disaster Information Screen'), findsOneWidget, reason: 'Navigation to Disaster Information failed');
//   });
// }


// // Simulated WebSocket server
// class MockWebSocketServer {
//   late int port;
//   late String lastMessage;

//   Future<MockWebSocketServer> start() async {
//     // Simulate starting a WebSocket server
//     // You might use a real WebSocket server in your actual implementation
//     // For simplicity, we're using a mock server in this example
//     port = 80;
//     return this;
//   }

//   Future<void> close() async {
//     // Simulate closing the WebSocket server
//     // You might stop a real WebSocket server in your actual implementation
//   }

//   // void handleWebSocket(WebSocket socket) {
//   //   socket.listen((data) {
//   //     // Handle incoming WebSocket messages
//   //     lastMessage = data;
//   //   });
//   // }
// }

// // Function to start the WebSocket server
// Future<MockWebSocketServer> startWebSocketServer() async {
//   final server = MockWebSocketServer();
//   await server.start();
//   return server;
// }



import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/main.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  testWidgets('WebSocket Client Integration Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Replace the following values with your server details
    const String serverUrl = 'ws://133.242.143.29:80';
    const String authenticationCode = 'your_authentication_code';

    // Connect to the WebSocket server
    final channel = IOWebSocketChannel.connect(serverUrl);

    // Send an authentication message
    final authenticationMessage = {
      'data-type': 'authentication',
      'authentication-code': authenticationCode,
    };
    channel.sink.add(jsonEncode(authenticationMessage));

    // Wait for the authentication response
    final authenticationResponse = await channel.stream.first;
    final decodedAuthenticationResponse = jsonDecode(authenticationResponse);

    // Perform assertions on the authentication response
    expect(decodedAuthenticationResponse['data-type'], 'authentication');
    expect(decodedAuthenticationResponse['authentication-code'], authenticationCode);
    expect(decodedAuthenticationResponse['response-result'], 200);

    // Send a test "send-message" message
    final sendMessageMessage = {
      'data-type': 'send-message',
      'authentication-code': authenticationCode,
      'distribution-id': 'your_distribution_id',
      'content': 'your_message_content',
    };
    channel.sink.add(jsonEncode(sendMessageMessage));

    // Wait for the broadcast message
    final broadcastMessage = await channel.stream.first;
    final decodedBroadcastMessage = jsonDecode(broadcastMessage);

    // Perform assertions on the broadcast message
    expect(decodedBroadcastMessage['data-type'], 'send-message');
    expect(decodedBroadcastMessage['authentication-code'], authenticationCode);
    expect(decodedBroadcastMessage['distribution-id'], 'your_distribution_id');
    // Add more assertions based on your server logic

    // Close the WebSocket connection
    channel.sink.close();

    // Verify initial state
    expect(find.text('Server 1'), findsOneWidget);
    expect(find.text('Server 2 is selected'), findsNothing);

    // Tap Server 2 checkbox
    await tester.tap(find.text('Server 2'));
    await tester.pump();

    // Verify that Server 2 is selected
    expect(find.text('Server 2 is selected'), findsNothing);
    expect(find.text('Server 2'), findsOneWidget);

    // Tap the Connect Server Button
    await tester.tap(find.text('Connect Server Button'));
    await tester.pump();

        // Check for successful connection or an error message
    if (find.text('Connected to Server 2', skipOffstage: false).evaluate().isEmpty) {
      // Connection failed, assert an error
      fail('Failed to connect to Server 2');
    }

    // Verify the connected state
    expect(find.text('Connected to Server 2'), findsOneWidget, reason: 'Connection to Server 2 failed');

    // Tap the Authentication Button
    await tester.tap(find.text('Authentication Button'));
    await tester.pump();

    // Tap the Disaster Information Button
    await tester.tap(find.text('Disaster Information Button'));
    await tester.pump();
  });
}


// import 'package:flutter_test/flutter_test.dart';
// import 'package:chat_app/main.dart';
//
// void main() {
//   testWidgets('Connect to Server 2, Authenticate, and Receive Disaster Information', (WidgetTester tester) async {
//     await tester.pumpWidget(const MyApp());

// Create a WebSocket channel
// final channel = IOWebSocketChannel.connect('wss://your_server_url');
//
// await tester.pumpWidget(MyApp(channel: channel));
//
//     // Verify initial state
//     expect(find.text('Server 1'), findsOneWidget, reason: 'Initial state not as expected');
//     expect(find.text('Server 2 is selected'), findsNothing, reason: 'Initial state not as expected');
//
//     // Tap Server 2 checkbox
//     await tester.tap(find.text('Server 2'));
//     await tester.pump();
//
//     // Verify that Server 2 is selected
//     expect(find.text('Server 1 is selected'), findsNothing, reason: 'Server 2 not selected');
//     expect(find.text('Server 2'), findsOneWidget, reason: 'Server 2 not selected');
//
//     // Tap the Connect Server Button
//     await tester.tap(find.byKey(const Key('connectServerButton')));
//     await tester.pump();
//
//     // Check for successful connection or an error message
//     if (find.text('Connected to Server 2', skipOffstage: false).evaluate().isEmpty) {
//       // Connection failed, assert an error
//       fail('Failed to connect to Server 2');
//     }
//
//     // Verify the connected state
//     expect(find.text('Connected to Server 2'), findsOneWidget, reason: 'Connection to Server 2 failed');
//
//     // Tap the Authentication Button
//     await tester.tap(find.byKey(const Key('authenticationButton')));
//     await tester.pump();
//
//     // Check for successful authentication or an error message
//     if (find.text('Authentication successful', skipOffstage: false).evaluate().isEmpty) {
//       // Authentication failed, assert an error
//       fail('Authentication failed');
//     }
//
//     // Verify the authentication state
//     expect(find.text('Authentication successful'), findsOneWidget, reason: 'Authentication failed');
//
//     // Tap the Disaster Information Button
//     await tester.tap(find.byKey(const Key('disasterInformationButton')));
//     await tester.pump();
//
//     // Check for successful receipt of disaster information or an error message
//     if (find.text('Disaster Information Screen', skipOffstage: false).evaluate().isEmpty) {
//       // Failed to receive disaster information, assert an error
//       fail('Failed to receive disaster information');
//     }
//
//     // Verify the navigation to disaster information
//     expect(find.text('Disaster Information Screen'), findsOneWidget, reason: 'Navigation to Disaster Information failed');
//   });
// }
