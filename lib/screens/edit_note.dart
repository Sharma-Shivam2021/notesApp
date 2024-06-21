import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/constants/helper_functions.dart';
import 'package:notes/constants/theme.dart';
import 'package:notes/models/notes_model.dart';
import 'package:notes/screens/notes.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({
    super.key,
    required this.noteData,
    required this.noteId,
  });
  final Map<String, dynamic> noteData;
  final String noteId;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late QuillController controller;
  final _formKey = GlobalKey<FormState>();
  bool _editingNote = false;
  String? _title;

  @override
  void dispose() {
    _editingNote = false;
    super.dispose();
  }

  void _showErrorSnackBar(String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e),
      ),
    );
  }

  void _closeEditScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NotesScreen(),
      ),
    );
  }

  void _editNote() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    _formKey.currentState!.reset();
    setState(() {
      _editingNote = true;
    });

    final editedNote = NotesModel(
      userId: widget.noteData['userId'],
      noteTitle: _title!,
      noteDescription: jsonEncode(controller.document.toDelta().toJson()),
      noteDate: widget.noteData['noteDate'],
    );
    final result = await editNote(editedNote, widget.noteId);
    if (!result.$1) {
      setState(() {
        _editingNote = false;
      });
      _showErrorSnackBar(result.$2!);
    }
    setState(() {
      _editingNote = false;
    });
    _closeEditScreen();
  }

  @override
  void initState() {
    final document = Document.fromJson(
      jsonDecode(
        widget.noteData['noteDescription'],
      ),
    );
    controller = QuillController(
      document: document,
      readOnly: false,
      selection: const TextSelection.collapsed(offset: 0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noteData = widget.noteData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            onPressed: _editNote,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: _editingNote
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 12.0, right: 12.0, bottom: 10.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                            onSaved: (title) {
                              _title = title;
                            },
                            initialValue: noteData['noteTitle'],
                            validator: titleValidator,
                            enableSuggestions: true,
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 10),
                          QuillToolbar.simple(
                            configurations:
                                buildQuillSimpleToolbarConfigurations(
                                    controller),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colorScheme.secondaryContainer,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: QuillEditor.basic(
                              focusNode: FocusNode(),
                              configurations: QuillEditorConfigurations(
                                controller: controller,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
