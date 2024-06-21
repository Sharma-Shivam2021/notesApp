import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  final String userId;
  final String noteTitle;
  final String noteDescription;
  final Timestamp noteDate;

  NotesModel({
    required this.userId,
    String? noteId,
    required this.noteTitle,
    required this.noteDescription,
    required this.noteDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'noteTitle': noteTitle,
      'noteDescription': noteDescription,
      'noteDate': noteDate,
    };
  }
}
