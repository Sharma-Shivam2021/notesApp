import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:notes/constants/helper_functions.dart';

class OtherAuthOptions extends StatefulWidget {
  const OtherAuthOptions({super.key});

  @override
  State<OtherAuthOptions> createState() => _OtherAuthOptionsState();
}

class _OtherAuthOptionsState extends State<OtherAuthOptions> {
  void showErrorSnackBar(e) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e ?? 'Authentication Failed'),
      ),
    );
  }

  void _loginWithGoogle() async {
    final result = await googleSignIn();
    if (!result.$1) {
      showErrorSnackBar(result.$2);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SignInButton(
          Buttons.Google,
          onPressed: () {
            _loginWithGoogle();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        )
      ],
    );
  }
}
