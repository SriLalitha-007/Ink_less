import 'package:flutter/material.dart';
import 'package:flutter_googledocs_clone/colors.dart';
import 'package:flutter_googledocs_clone/repositary/auth_repositary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref) {
    ref.read(AuthRepositaryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref),
          icon: Image.asset(
            'asset/images/g-logo-2.png',
            height: 20,
          ),
          label: const Text(
            'sign in with google',
            style: TextStyle(color: kBlackColour),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor,
            minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}
