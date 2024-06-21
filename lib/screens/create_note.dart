import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/helper_functions.dart';
import 'package:notes/constants/theme.dart';
import 'package:notes/models/notes_model.dart';
import 'package:flutter_quill/flutter_quill.dart';

final _auth = FirebaseAuth.instance;

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final QuillController _quillController = QuillController.basic();
  bool _creatingNote = false;
  String? _title;
  String? _userId;

  void _closeAddScreen() {
    Navigator.of(context).pop();
  }

  void _showErrorSnackBar(String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e),
      ),
    );
  }

  void _submitNoteForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    _formKey.currentState!.reset();
    setState(() {
      _creatingNote = true;
    });
    _userId = _auth.currentUser?.uid;
    final newNote = NotesModel(
      userId: _userId!,
      noteTitle: _title!,
      noteDescription: jsonEncode(
        _quillController.document.toDelta().toJson(),
      ),
      noteDate: Timestamp.now(),
    );
    final result = await createNewNote(newNote);
    if (!result.$1) {
      setState(() {
        _creatingNote = false;
      });
      _showErrorSnackBar(result.$2!);
    }
    setState(() {
      _creatingNote = false;
    });
    _closeAddScreen();
  }

  @override
  void dispose() {
    _creatingNote = false;
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          IconButton(
            onPressed: _submitNoteForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _creatingNote
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 12.0,
                  right: 12.0,
                  bottom: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            validator: titleValidator,
                            enableSuggestions: true,
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 10),
                          QuillToolbar.simple(
                            configurations:
                                buildQuillSimpleToolbarConfigurations(
                                    _quillController),
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
                                controller: _quillController,
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
