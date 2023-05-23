import 'package:flutter/material.dart';
import 'package:flutter_googledocs_clone/colors.dart';
import 'package:flutter_googledocs_clone/common/widgets/loader.dart';
import 'package:flutter_googledocs_clone/models/document_model.dart';
import 'package:flutter_googledocs_clone/models/error_model.dart';
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

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
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
      body: FutureBuilder<ErrorModel?>(
          future: ref.watch(documentRepositaryProvider).getDocuments(
                ref.watch(userProvider)!.token,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.data!.data == null) {
              return Text('snapshot.data!.error.toString()');
            }
            //print('1234567890');
            //print(snapshot.data!.data);
            return Center(
              child: Container(
                width: 600,
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (context, index) {
                    DocumentModel document = snapshot.data!.data[index];

                    return InkWell(
                      onTap: () => navigateToDocument(context, document.id),
                      child: SizedBox(
                        height: 50,
                        child: Card(
                          child: Center(
                            child: Text(
                              document.title,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
