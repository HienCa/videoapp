import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderName;
  final String receierId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderName,
      required this.receierId,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receierId': receierId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
