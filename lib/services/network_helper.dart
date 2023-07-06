import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHelper {
  Future getData(String url) async {
    try {
      String urlPrefix = 'http://192.168.0.175:4000/v1';
      String finalUrl = urlPrefix + url;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = await prefs.getString('accessToken') ?? 'null';

      http.Response response = await http
          .get(Uri.parse(finalUrl), headers: {'accessToken': accessToken});

      String data = response.body;
      var decodedData = jsonDecode(data);
      return {'statusCode': response.statusCode, 'data': decodedData};
    } catch (err) {
      print(err);
    }
  }

  Future postData(String url, data) async {
    try {
      String urlPrefix = 'http://192.168.0.175:4000/v1';
      String finalUrl = urlPrefix + url;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = await prefs.getString('accessToken') ?? 'null';

      var body = jsonEncode(data);

      http.Response response = await http.post(
        Uri.parse(finalUrl),
        body: body,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'accessToken': accessToken
        },
      );

      String responseData = response.body;
      var decodedData = jsonDecode(responseData);
      return {'statusCode': response.statusCode, 'data': decodedData};
    } catch (err) {
      print('2');
      print(err);
    }
  }

  Future deleteRequest(String url) async {
    try {
      String urlPrefix = 'http://192.168.0.175:4000/v1';
      String finalUrl = urlPrefix + url;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = await prefs.getString('accessToken') ?? 'null';

      http.Response response = await http.delete(
        Uri.parse(finalUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'accessToken': accessToken
        },
      );

      String responseData = response.body;
      var decodedData = jsonDecode(responseData);
      return {'statusCode': response.statusCode, 'data': decodedData};
    } catch (err) {
      print(err);
    }
  }
}
