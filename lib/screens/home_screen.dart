import 'package:flutter/material.dart';
import 'package:flutter_googledocs_clone/repositary/auth_repositary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(ref.watch(userProvider)!.uid),
      ),
    );
  }
}
