import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dto/localizations.dart';

class ApiConnector {
  static String url = 'https://api.test.millennium-falcon.team/';

  //Get field mappings
  static Future<void> getLocalizations() async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      LocalizationDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load mapping: ${response.statusCode} ${response.body}');
    }
  }

  //Store qr
  static Future<void> sendQR(String qrData) async {
    Map<String, String> body = {'qr': qrData};

    var response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to send qr: ${response.statusCode} ${response.body}');
    }
  }
}
