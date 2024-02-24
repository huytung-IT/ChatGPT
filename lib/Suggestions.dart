class Suggestion {
  final String content;
  final String describe;

  Suggestion({required this.content, required this.describe});
}

class ChatGptRequestSuggestions {
  static Map<String,dynamic> suggestionMap = {
    "Default":{
      "model":"gpt-3.5-turbo",
      "messages":[
        {
          "role": "system",
          "content": "You will be assistant."
        },
        {
          "role": "user",
          "content": "She no went to the market."
        }
      ]
    },
    "Grammar correction":{
      "model":"gpt-3.5-turbo",
      "messages":[
        {
          "role": "system",
          "content": "You will be provided with statements, and your task is to convert them to standard English."
        },
        {
          "role": "user",
          "content": "She no went to the market."
        }
      ],
      "temperature":0.7,
      "max_tokens":64,
      "top_p":1
    },
    "Parse unstructured data":{
      "model":"gpt-3.5-turbo",
      "messages":[
        {
          "role": "system",
          "content": "You will be provided with unstructured data, and your task is to parse it into CSV format."
        },
        {
          "role": "user",
          "content": "There are many fruits that were found on the recently discovered planet Goocrux. There are neoskizzles that grow there, which are purple and taste like candy. There are also loheckles, which are a grayish blue fruit and are very tart, a little bit like a lemon. Pounits are a bright green color and are more savory than sweet. There are also plenty of loopnovas which are a neon pink flavor and taste like cotton candy. Finally, there are fruits called glowls, which have a very sour and bitter taste which is acidic and caustic, and a pale orange tinge to them."
        }
      ],
      "temperature":0.7,
      "max_tokens":64,
      "top_p":1
    }
  };


  static dynamic getSuggestionAndBuildApiRequest(String keySuggestName, String textFromUser) {
    var requestBuildFromSuggestion= suggestionMap[keySuggestName];
    requestBuildFromSuggestion["messages"][1]["content"]=textFromUser;

    return requestBuildFromSuggestion;
  }
}