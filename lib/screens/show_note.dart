import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/constants/theme.dart';
import 'package:notes/screens/edit_note.dart';

class ShowNoteScreen extends StatelessWidget {
  const ShowNoteScreen({
    super.key,
    required this.noteData,
    required this.noteId,
  });
  final Map<String, dynamic> noteData;
  final String noteId;

  @override
  Widget build(BuildContext context) {
    final document = Document.fromJson(
      jsonDecode(
        noteData['noteDescription'],
      ),
    );
    final quillController = QuillController(
      document: document,
      readOnly: true,
      selection: const TextSelection.collapsed(offset: 0),
    );
    final theme = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(noteData['noteTitle']),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      EditNoteScreen(noteData: noteData, noteId: noteId),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme == Brightness.light ? gradient : darkGradient,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: quillController,
            ),
          ),
        ),
      ),
    );
  }
}
