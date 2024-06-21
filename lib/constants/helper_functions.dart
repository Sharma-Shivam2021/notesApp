import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/models/notes_model.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

// Auth Form Validators
String? usernameValidator(String? username) {
  if (username == null || username.isEmpty || username.trim().length < 5) {
    return "Please enter a valid Username of length at least 5 characters long";
  }
  return null;
}

String? emailValidator(String? email) {
  if (email == null || email.trim().isEmpty || !email.contains('@')) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? passwordValidator(String? password) {
  if (password == null || password.trim().length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

// Google Sign-In

Future<(bool, String?)> googleSignIn() async {
  try {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return (false, "Authentication cancelled");
    }

    final googleAuth = await googleUser.authentication;

    final cred = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCredential = await _auth.signInWithCredential(cred);
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'username': userCredential.user!.displayName,
      'email': userCredential.user!.email,
    });

    return (true, 'Successful');
  } catch (e) {
    return (false, e.toString());
  }
}

// SignOut function available on NotesScreen

Future<String?> allSignOut() async {
  try {
    final user = _auth.currentUser;
    if (user == null) {
      return "No user is currently signed in.";
    }

    bool isGoogleUser = user.providerData
        .any((userInfo) => userInfo.providerId == 'google.com');

    if (isGoogleUser) {
      await GoogleSignIn().signOut();
    }

    await _auth.signOut();
    return "Successfully signed out";
  } catch (e) {
    return e.toString();
  }
}

// Create Note Form Functionalities

String? titleValidator(String? title) {
  if (title == null || title.isEmpty) {
    return "Please enter a valid title of length at most 20 characters long";
  }
  return null;
}

Future<(bool, String?)> createNewNote(NotesModel newNote) async {
  try {
    await _firestore.collection('notes').add(newNote.toMap());
    return (true, null);
  } catch (e) {
    return (false, e.toString());
  }
}

void undo(Map<String, dynamic> deletedNoteInformation) {
  _firestore.collection('notes').add(deletedNoteInformation);
}

Future<(bool, String?)> delete(String noteId) async {
  try {
    await _firestore.collection('notes').doc(noteId).delete();
    return (true, null);
  } catch (e) {
    return (false, e.toString());
  }
}

Future<(bool, String?)> editNote(NotesModel editedNote, String noteId) async {
  try {
    await _firestore.collection('notes').doc(noteId).set(editedNote.toMap());
    return (true, null);
  } catch (e) {
    return (false, e.toString());
  }
}

//Quill Tool Bar Configuration

QuillSimpleToolbarConfigurations buildQuillSimpleToolbarConfigurations(
  quillController,
) {
  return QuillSimpleToolbarConfigurations(
    controller: quillController,
    showColorButton: false,
    showBackgroundColorButton: false,
    showIndent: false,
    showAlignmentButtons: true,
    showClearFormat: false,
    showClipboardCopy: false,
    showClipboardCut: false,
    showClipboardPaste: false,
    showSearchButton: false,
    showCodeBlock: false,
    showDividers: false,
    showFontFamily: false,
    showInlineCode: false,
    showLink: false,
    showDirection: false,
    showQuote: false,
    showSubscript: false,
    showSuperscript: false,
    color: Colors.red,
    toolbarSectionSpacing: 1,
    toolbarIconAlignment: WrapAlignment.start,
    sharedConfigurations: const QuillSharedConfigurations(
      locale: Locale('en'),
    ),
  );
}
