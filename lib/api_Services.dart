import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiServices {

  static Future<dynamic> sendChatRequest(dynamic requestBuildFromSuggestion) async {
    try {
      var url = Uri.parse('https://api.openai.com/v1/chat/completions');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer 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'
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