import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_googledocs_clone/colors.dart';
import 'package:flutter_googledocs_clone/repositary/auth_repositary.dart';
import 'package:flutter_googledocs_clone/repositary/document_repositary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void signOut(WidgetRef ref) {
    ref.read(authRepositaryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    print(token);
    final errorModel =
        await ref.read(documentRepositaryProvider).createDocument(token);

    if (errorModel.data != null) {
      print("Inside if !@#%^&*()(*&^%#)");
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(SnackBar(
        content: Text(errorModel.error!),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => createDocument(context, ref),
            icon: const Icon(
              Icons.add,
              color: kBlackColour,
            ),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: kRedColour,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(ref.watch(userProvider)!.uid),
      ),
    );
  }
}
