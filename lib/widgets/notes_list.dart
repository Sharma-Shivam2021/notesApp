import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/widgets/note_list_view.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _firestore
        .collection('notes')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('noteDate', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (ctx, notesSnapshot) {
        if (notesSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!notesSnapshot.hasData || notesSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Messages Found'),
          );
        }
        if (notesSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        final loadedNotes = notesSnapshot.data!.docs;
        return NoteListView(loadedNotes: loadedNotes);
      },
    );
  }
}
