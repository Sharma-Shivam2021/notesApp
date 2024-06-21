import 'package:flutter/material.dart';
import 'package:notes/constants/helper_functions.dart';
import 'package:notes/screens/create_note.dart';
import 'package:notes/widgets/notes_list.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  void _signOut() async {
    final res = await allSignOut();
    if (res != null && res.isNotEmpty) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const NotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const CreateNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
