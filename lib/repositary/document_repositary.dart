import 'dart:convert';

import 'package:flutter_googledocs_clone/constants.dart';
import 'package:flutter_googledocs_clone/models/document_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../models/error_model.dart';

final documentRepositaryProvider = Provider(
  (ref) => DocumentRepositary(
    client: Client(),
  ),
);

class DocumentRepositary {
  final Client _client;
  DocumentRepositary({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occured.',
      data: null,
    );
    try {
      var res = await _client.post(
        Uri.parse('$host/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );
      //print(res.statusCode);
      switch (res.statusCode) {
        case 200:
          error = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        default:
          error = ErrorModel(
            error: res.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}