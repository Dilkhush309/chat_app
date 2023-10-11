class ChatMessage {
 late String senderName;
 late String timestamp;
 late String message;

  ChatMessage({
    required this.senderName,
    required this.timestamp,
    required this.message,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    senderName = json['senderName'];
    timestamp = json['timestamp'];
    message = json['message'];
  }
}
