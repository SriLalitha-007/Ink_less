import 'dart:convert';
import 'dart:html';

import 'package:flutter_googledocs_clone/models/error_model.dart';
import 'package:flutter_googledocs_clone/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_googledocs_clone/constants.dart';
import 'package:http/http.dart';

final authRepositaryProvider = Provider(
  (ref) => AuthRepositary(
    googleSignIn: GoogleSignIn(),
    client: Client(),
  ),
);
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepositary {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  AuthRepositary({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occured.',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl!,
          uid: '',
          token: '',
        );
        var res = await _client.post(Uri.parse('$host/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });
        switch (res.statusCode) {
          case 200:
            print('IN CASE 200');
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
            );
            error = ErrorModel(error: null, data: newUser);
            break;
          default:
            throw 'some error occurdkfjasdjasdjasdjasdh';
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
