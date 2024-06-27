import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ApiServices {
  static Future<dynamic> sendChatRequest(
      dynamic requestBuildFromSuggestion) async {
    try {
      var url = Uri.parse('https://api.openai.com/v1/chat/completions');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer sk-proj-LzLojUuCmlJ9tnNJFMsDT3BlbkFJ6XS5GPCh1KoCrbDCV61t'
      };
      if (requestBuildFromSuggestion.containsKey("prompt")) {
        url = Uri.parse('https://api.openai.com/v1/images/generations');
      }else if(requestBuildFromSuggestion.containsKey("input")){
        url = Uri.parse('https://api.openai.com/v1/audio/speech');
      }else {
        url = Uri.parse('https://api.openai.com/v1/chat/completions');
      }

      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBuildFromSuggestion),
      );

      if (response.statusCode == 200) {
        var temp = json.decode(utf8.decode(response.bodyBytes));
        return temp;
      } else {
        throw Exception(
            'Failed to send question to API: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  static Future<dynamic> createImage(
      dynamic requestBuildFromSuggestion) async {
    try {
      var url = Uri.parse('https://api.openai.com/v1/images/generations');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
        'Bearer sk-proj-LzLojUuCmlJ9tnNJFMsDT3BlbkFJ6XS5GPCh1KoCrbDCV61t'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBuildFromSuggestion),
      );

      if (response.statusCode == 200) {
        var temp = json.decode(utf8.decode(response.bodyBytes));
        return temp;
      } else {
        throw Exception(
            'Failed to send question to API: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: ---------$error------------');
    }
  }

  static Future<dynamic> uploadFile(PlatformFile file) async {
    try {
      var url = Uri.parse('https://api.openai.com/v1/files');
      var headers = {
        'Authorization':
            'Bearer sk-proj-LzLojUuCmlJ9tnNJFMsDT3BlbkFJ6XS5GPCh1KoCrbDCV61t'
      };

      var request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'purpose': 'fine-tune'
      });
      request.files.add(await http.MultipartFile.fromPath('file', file.path!));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));
        return result;
      } else {
        throw Exception(
            'Failed to upload file to API: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  static Future<dynamic> getFileContent(String fileId) async {
    try {
      var url = Uri.parse('https://api.openai.com/v1/files/$fileId/content');
      var headers = {
        'Authorization': 'Bearer sk-proj-LzLojUuCmlJ9tnNJFMsDT3BlbkFJ6XS5GPCh1KoCrbDCV61t'
      };

      var response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var fileContent = json.decode(utf8.decode(response.bodyBytes));
        return fileContent;
      } else {
        throw Exception('Failed to get file content from API: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }
  static Future<dynamic> audio(
      dynamic requestBuildFromSuggestion) async {
    try {
      var url = Uri.parse('https://api.openai.com/v1/audio/speech');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
        'Bearer sk-proj-LzLojUuCmlJ9tnNJFMsDT3BlbkFJ6XS5GPCh1KoCrbDCV61t'
      };

      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBuildFromSuggestion),
      );

      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        var temp = json.decode(responseBody);
        return temp;
      } else {
        throw Exception('Không thể gửi câu hỏi đến API: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Lỗi: $error');
      throw error;
    }
  }
}
