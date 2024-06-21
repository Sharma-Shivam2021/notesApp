import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/helper_functions.dart';
import 'package:notes/screens/edit_note.dart';
import 'package:notes/screens/show_note.dart';

final _firestore = FirebaseFirestore.instance;

class NoteListView extends StatefulWidget {
  const NoteListView({
    super.key,
    required this.loadedNotes,
  });
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> loadedNotes;

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  void _showUndoSnackBar(Map<String, dynamic> deletedNoteInformation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            undo(deletedNoteInformation);
          },
        ),
      ),
    );
  }

  void _showErrorSnackBar(String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e),
      ),
    );
  }

  void _onDismissed(noteId) async {
    try {
      final deletedNote =
          await _firestore.collection('notes').doc(noteId).get();
      final deletedNoteInformation = deletedNote.data()!;
      _showUndoSnackBar(deletedNoteInformation);
      final result = await delete(noteId);
      if (!result.$1) {
        _showErrorSnackBar(result.$2!);
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.loadedNotes.length,
      itemBuilder: (context, index) {
        final note = widget.loadedNotes[index];
        final noteData = note.data();
        return Dismissible(
          onDismissed: (direction) {
            _onDismissed(note.id);
          },
          key: Key(note.id),
          child: Card(
            child: ListTile(
              title: Text(noteData['noteTitle']),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) =>
                          EditNoteScreen(noteData: noteData, noteId: note.id),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ShowNoteScreen(
                      noteData: noteData,
                      noteId: note.id,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
