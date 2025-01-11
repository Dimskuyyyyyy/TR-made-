import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionHistory {
  final String id;
  final String userId;
  final String type;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double result;
  final DateTime timestamp;

  ConversionHistory({
    required this.id,
    required this.userId,
    required this.type,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
      'inputValue': inputValue,
      'result': result,
      'timestamp': timestamp,
    };
  }

  factory ConversionHistory.fromMap(String id, Map<String, dynamic> map) {
    return ConversionHistory(
      id: id,
      userId: map['userId'],
      type: map['type'],
      fromUnit: map['fromUnit'],
      toUnit: map['toUnit'],
      inputValue: map['inputValue'],
      result: map['result'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}