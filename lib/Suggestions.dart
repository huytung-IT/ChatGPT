import 'dart:ui';

class Suggestion {
  final String content;
  final String describe;

  Suggestion({required this.content, required this.describe});
}

class ChatGptRequestSuggestions {
  static Map<String, dynamic> suggestionMap = {
    "Mặc định": {
      "model": "gpt-4o",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hello!"}
      ]
    },
    "Chuyển sang âm thanh": {
      "model": "tts-1",
      "input": "The quick brown fox jumped over the lazy dog.",
      "voice": "alloy"
    },
    // "Dịch tiếng anh": {
    //   "model": "gpt-4o",
    //   "messages": [
    //     {
    //       "role": "system",
    //       "content":
    //           "You will be provided with statements, and your task is to convert them to standard English."
    //     },
    //     {"role": "user", "content": "Hello!"}
    //   ],
    //   "temperature": 0.7,
    //   "max_tokens": 64,
    //   "top_p": 1
    // },

    "Tạo ảnh": {
      "model": "dall-e-3",
      "prompt": "A cute baby sea otter",
      "n": 1,
      "size": "1024x1024"
    }
  };

  static dynamic getSuggestionAndBuildApiRequest(
      String keySuggestName, String textFromUser) {
    var requestBuildFromSuggestion = suggestionMap[keySuggestName];
    if (keySuggestName == "Tạo ảnh") {
      requestBuildFromSuggestion["prompt"] = textFromUser;
    } else if (keySuggestName == "Chuyển sang âm thanh") {
      requestBuildFromSuggestion["input"] = textFromUser;
    } else {
      requestBuildFromSuggestion["messages"][1]["content"] = textFromUser;
    }

    return requestBuildFromSuggestion;
  }
}
