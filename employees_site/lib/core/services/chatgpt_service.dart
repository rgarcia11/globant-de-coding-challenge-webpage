// import 'package:flutter_dotenv/flutter_dotenv.dart';
// dotenv.env['VAR_NAME'];
import 'dart:convert';

import 'package:employees_site/core/services/api_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

String openAiKey = dotenv.env['OPENAI_API_KEY']!;

RegExp extractJSONRegExp = RegExp(r'{(.*\n)*}');

Future<String?> newUserChatGPT(String prompt) async {
  String intro = '''Hi, dear ChatGPT. 
  I need to insert a row in my database, and I need your help. 
  I will give you a text and I need you to extract three values from it: 
  "department", "job" and "name". 
  Try to avoid returning the word "department", "job" or "name" in your answer.
  Your answer should only be a JSON containing the extracted values. 
  Example: "I'm Roger and I'd like to be a data
  engineer at your company's data department". The answer would be:
  '{"department": "data", "job": "data engineer", "name": "Roger"}'
  in the department name. 
  
  The actual text is the following:
  

  ''';
  Map<String, String> message = {
    'role': 'user',
    'content': '$intro$prompt',
  };
  Response res;
  try {
    res = await http.post(
      Uri.parse(ApiConfig.chatGPTUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${openAiKey.trim()}',
      },
      body: jsonEncode({
        "model": ApiConfig.chatGPTModel,
        "messages": [message],
      }),
    );
  } catch (e) {
    return e.toString();
  }
  try {
    if (res.statusCode == 200) {
      String content = jsonDecode(res.body)['choices'][0]['message']['content'];
      content = content.trim();
      return extractJSONRegExp.firstMatch(content)?.group(0);
    }
    return 'An internal error occurred: $res, ${res.body}';
  } catch (e) {
    return e.toString();
  }
}
