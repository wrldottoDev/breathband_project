import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final String mood;
  final DateTime date;

  Note({
    required this.id,
    required this.text,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'text': text,
        'mood': mood,
        'date': date.toUtc(),
      };

  factory Note.fromMap(String id, Map<String, dynamic> map) => Note(
        id: id,
        text: map['text'] ?? '',
        mood: map['mood'] ?? '',
        date: (map['date'] as Timestamp).toDate(),
      );
}