import 'dart:convert';
import 'package:flutter_googledocs_clone/models/error_model.dart';
import 'package:flutter_googledocs_clone/models/user_model.dart';
import 'package:flutter_googledocs_clone/repositary/local_storage_repositary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_googledocs_clone/constants.dart';
import 'package:http/http.dart';
//const jwt = require('jsonwebtoken');

final authRepositaryProvider = Provider(
  (ref) => AuthRepositary(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepositary: LocalStorageRepositary(),
  ),
);
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepositary {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepositary _localStorageRepositary;
  AuthRepositary(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepositary localStorageRepositary})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepositary = localStorageRepositary;

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
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
        );
        var res = await _client.post(Uri.parse('$host/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });
        //print(res.statusCode);
        switch (res.statusCode) {
          case 200:
            print('IN CASE 200');
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepositary.setToken(newUser.token);

            break;
          default:
            throw 'some error occured';
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occured.',
      data: null,
    );
    try {
      String? token = await _localStorageRepositary.getToken();

      if (token != null) {
        var res = await _client.get(Uri.parse('$host/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        //print(res.statusCode);
        switch (res.statusCode) {
          case 200:
            print('IN CASE 200');
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepositary.setToken(newUser.token);

            break;
          default:
            throw 'some error occured';
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepositary.setToken('');
  }
}
