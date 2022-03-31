import 'dart:convert';

import 'package:http/http.dart' as http;

import 'enum.dart';

class ApiBase {
  Duration timeoutDuration;
  Map<String, String>? headers = {};
  String baseUrl = 'altodo.c1-na.altogic.com';

  ApiBase({
    this.headers,
    this.timeoutDuration = const Duration(seconds: 15),
  });
  static late final ApiBase instance;

  String _urlCreator({
    required String path,
    Map<String, dynamic>? queryMap,
  }) {
    Uri url;
    Map<String, dynamic> map = queryMap ?? {};
    map.removeWhere((key, value) => value == null);
    url = Uri.https(baseUrl, path, map);

    return url.toString();
  }

  Future<Map<String, dynamic>?> callApi({
    required String path,
    required HttpMethod httpMethod,
    Map<String, dynamic>? params,
    int? languageType,
    String? paramText,
    Map<String, String>? fields,
    bool isCheckConnectionRequest = false,
  }) async {
    http.Response? response;

    String urlPath = _urlCreator(
      path: path,
      queryMap:
          httpMethod == HttpMethod.get || paramText != null ? params : null,
    );

    if (paramText != null) {
      headers!['content-type'] = 'application/string';
    } else {
      headers!['content-type'] = 'application/json';
    }

    var url = Uri.parse(urlPath);

    try {
      switch (httpMethod) {
        case HttpMethod.get:
          response = await http
              .get(
                url,
                headers: headers,
              )
              .timeout(
                timeoutDuration,
              );
          break;
        case HttpMethod.post:
          String bodyData = paramText ?? json.encode(params);
          response = await http
              .post(
                url,
                headers: headers,
                body: bodyData,
              )
              .timeout(
                timeoutDuration,
              );
          break;
        case HttpMethod.put:
          var req = http.MultipartRequest('PUT', url)..fields.addAll(fields!);
          await req.send();
          break;
        case HttpMethod.delete:
          String bodyData = paramText ?? json.encode(params);
          response = await http
              .delete(
                url,
                headers: headers,
              )
              .timeout(
                timeoutDuration,
              );
          break;
        default:
      }
      if (response != null) {
        if (response.statusCode == 200) {
          if (response.body.isEmpty) {
            return null;
          }
          return json.decode(response.body);
        } else if (response.statusCode != 200) {
          String statusCode = response.statusCode.toString();
          throw Exception(
              'Failed to load data with code: ' + statusCode.toString());
        }
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }
}
