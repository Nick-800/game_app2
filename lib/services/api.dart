import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;


class Api {
  Future <Response> get (String url) async {
   var response = await http.get(
    Uri.parse(url),
   );
      if (kDebugMode) {
      print("REQUEST ON URL : $url");
      print("STATUS CODE : ${response.statusCode}");
      print("BODY : ${response.body}");
    }
    return response;
  }
}