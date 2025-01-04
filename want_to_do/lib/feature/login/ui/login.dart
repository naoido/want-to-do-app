import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../domains/google_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });

                  User? user = await Authentication.signInWithGoogle(context: context);
                  String? token = await user?.getIdToken();
                  debugPrint("token: $token");
                  setState(() {
                    _loading = false;
                  });
                }, child: const Text("ログイン"),
              )
            ],
          ),
        ),
        _loading ? Container(
          color: Colors.black26,
          child: const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              )
          ),
        ): Container()
      ],
    );
  }
}
