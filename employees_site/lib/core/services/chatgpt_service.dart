// import 'package:flutter_dotenv/flutter_dotenv.dart';
// dotenv.env['VAR_NAME'];
import 'dart:convert';

import 'package:employees_site/core/services/api_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ChatGPTService {
  String _openAiKey = dotenv.env['OPENAI_API_KEY']!;

  RegExp _extractEmployeeJSONRegExp = RegExp(r'{(.*\n?)*}');

  Future<String?> hireEmployeeChatGPT(String prompt) async {
    String intro = '''Hi, dear ChatGPT. 
  I need to insert a row in my database, and I need your help. 
  I will give you a text and I need you to extract three values from it: 
  "department", "job" and "name". 
  Try to avoid returning the word "department", "job" or "name" in your answer.
  Your answer should only be a JSON containing the extracted values. 
  Example: "I'm Roger and I'd like to be a data
  engineer at your company's data department". The answer would be:
  '{"department": "data", "job": "data engineer", "name": "Roger"}'
  Another example would be only the values: "Roger, data, data engineer" and the 
  answer would be '{"department": "data", "job": "data engineer", "name": "Roger"}'.
  
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
          'Authorization': 'Bearer ${_openAiKey.trim()}',
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
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        return _extractEmployeeJSONRegExp.firstMatch(content)?.group(0);
      }
      return 'An internal error occurred: $res, ${res.body}';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addEmployeeChatGPT(String prompt) async {
    String intro = '''Hi, dear ChatGPT. 
  I need to insert a row in my database, and I need your help. 
  I will give you a text and I need you to extract three values from it: 
  "department", "job" and "name". 
  Try to avoid returning the word "department", "job" or "name" in your answer.
  The answer may also contain a date indicated when this employee was hired.
  The format for the date should be for PostgreSQL, like "Fri, 15 Jan 2021 00:00:00 GMT"
  Your answer should only be a JSON containing the extracted values. 
  Example: "I'm Roger and I'd like to be a data
  engineer at your company's data department". The answer would be:
  '{"department": "data", "job": "data engineer", "name": "Roger", "datetime": <current_datetime in PostgreSQL format>}' 
  Another example: "I'm Olga and I joined as a designer at your design team on February the 2nd 2022."
  The answer would be: '{"department": "design", "job": "designer", "name": "Olga", "datetime": "Wed, 02 Feb 2022 00:00:00 GMT"}' 
  Another example would be only the values: "Roger, data, data engineer" and the 
  answer would be '{"department": "data", "job": "data engineer", "name": "Roger"}'.
  Your answer doesnt need to have the value department, but it needs the values 
  for name, department and job.

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
          'Authorization': 'Bearer ${_openAiKey.trim()}',
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
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        return _extractEmployeeJSONRegExp.firstMatch(content)?.group(0);
      }
      return 'An internal error occurred: $res, ${res.body}';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addDepartmentChatGPT(String prompt) async {
    String intro = '''Hi, dear ChatGPT. 
  I need to insert a row in my database, and I need your help. 
  I will give you a text and I need you to extract one value from it: 
  "department". 
  Try to avoid returning the word "department" in your answer.
  Your answer should only be a JSON containing the extracted value. 
  Example: "The new department is data". The answer would be:
  '{"department": "data"}' 
  Another example: "Let's create the design department".
  Another example would be only the values: "data" and the 
  answer would be '{"department": "data"}'.
  The answer would be: '{"department": "design"}' 

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
          'Authorization': 'Bearer ${_openAiKey.trim()}',
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
        print('Gatito interno botate');
        print(res.body);
        print('');
        print(jsonDecode(res.body));
        print('');
        print(jsonDecode(res.body)['choices']);
        print('');
        print(jsonDecode(res.body)['choices'][0]);
        print('');
        print(jsonDecode(res.body)['choices'][0]['message']);
        print('');
        print(jsonDecode(res.body)['choices'][0]['message']['content']);
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        print(content);
        print(_extractEmployeeJSONRegExp.firstMatch(content) ?? 'aiudax');
        print(_extractEmployeeJSONRegExp.firstMatch(content)?.group(0));
        return _extractEmployeeJSONRegExp.firstMatch(content)?.group(0);
      }
      return 'An internal error occurred: $res, ${res.body}';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addJobChatGPT(String prompt) async {
    String intro = '''Hi, dear ChatGPT. 
  I need to insert a row in my database, and I need your help. 
  I will give you a text and I need you to extract one value from it: 
  "job". 
  Try to avoid returning the word "job" in your answer.
  Your answer should only be a JSON containing the extracted value. 
  Example: "The new role is data engineer". The answer would be:
  '{"department": "data engineer"}' 
  Another example: "Let's create the designer job"
  The answer would be: '{"department": "designer"}' 
  Another example would be only the values: "data engineer" and the 
  answer would be '{"job": "data engineer"}'.

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
          'Authorization': 'Bearer ${_openAiKey.trim()}',
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
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        return _extractEmployeeJSONRegExp.firstMatch(content)?.group(0);
      }
      return 'An internal error occurred: $res, ${res.body}';
    } catch (e) {
      return e.toString();
    }
  }
}
