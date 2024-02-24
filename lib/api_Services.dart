import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiServices {

  static Future<dynamic> sendChatRequest(dynamic requestBuildFromSuggestion) async {
    try {
      var url = Uri.parse('');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': ''
      };


      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBuildFromSuggestion),
      );

      if (response.statusCode == 200) {
        var temp = json.decode(utf8.decode( response.bodyBytes));
        return temp;
      }
      else {
        throw Exception('Failed to send question to API: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


}