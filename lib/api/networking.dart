import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_app/main.dart';

class ServiceWithHeader {
  final String url;

  ServiceWithHeader(this.url);

  // get method with header

  Future data() async {
    Map<String, String> headersMap = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': "8bitchaps.com",
      'Access-Control-Allow-Methods': "GET, POST, OPTIONS",
      'Authorization': "Bearer ${MyApp.authTokenValue.replaceAll("\"", "")}",
    };
    final response = await http.get(Uri.parse(url), headers: headersMap);
    // print(response.body.toString());
    String data = response.body;
    if (data.length > 0) {
      return [response.statusCode, jsonDecode(data)];
    } else {
      return [response.statusCode];
    }
  }
}

class ServiceWithHeaderDataPost {
  final String url;
  final b;

  ServiceWithHeaderDataPost(this.url, this.b);

  // post method with header

  Future data() async {
    Map<String, String> headersData = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': "8bitchaps.com",
      'Access-Control-Allow-Methods': "GET, POST, OPTIONS",
      'Authorization': "Bearer ${MyApp.authTokenValue.replaceAll("\"", "")}",
    };
    final response = await http.post(
      Uri.parse(url),
      headers: headersData,
      body: jsonEncode(b),
    );
    String data = response.body;
    if (data.length > 0) {
      return [response.statusCode, jsonDecode(data)];
    } else {
      return [response.statusCode];
    }
  }
}

class ServiceWithDataPost {
  final String url;
  final Map<String, dynamic> b;

  ServiceWithDataPost(this.url, this.b);

  // this is used for login no authorization

  Future data() async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': "*",
        'Access-Control-Allow-Methods': "GET, POST, OPTIONS"
      },
      body: jsonEncode(b),
    );
    // print(response);
    String data = response.body;
    if (data.length > 0) {
      return [response.statusCode, jsonDecode(data)];
    } else {
      return [response.statusCode];
    }
  }
}
