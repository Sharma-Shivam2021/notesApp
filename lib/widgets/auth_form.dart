import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/helper_functions.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.isLogin,
  });
  final bool isLogin;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _username = "";
  var _email = "";
  var _password = "";
  var _isAuthenticated = false;
  final _formKey = GlobalKey<FormState>();

  void showErrorSnackBar(e) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? 'Authentication Failed'),
      ),
    );
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    _formKey.currentState!.reset();
    try {
      setState(() {
        _isAuthenticated = true;
      });
      if (widget.isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': _username,
          'email': _email,
        });
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(e);
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  void dispose() {
    _isAuthenticated = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!widget.isLogin)
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              onSaved: (username) {
                _username = username!;
              },
              validator: usernameValidator,
              enableSuggestions: false,
              autocorrect: false,
            ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            onSaved: (email) {
              _email = email!;
            },
            validator: emailValidator,
            enableSuggestions: false,
            autocorrect: false,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            onSaved: (password) {
              _password = password!;
            },
            validator: passwordValidator,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          _isAuthenticated
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.isLogin ? "Login" : "Signup"),
                ),
        ],
      ),
    );
  }
}
