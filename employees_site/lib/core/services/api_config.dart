class ApiConfig {
  static const String baseUrl = 'https://flask-app-exxaxfzfxq-uc.a.run.app';
  // static const String baseUrl = 'http://127.0.0.1:8080';
  static const String chatGPTUrl = 'https://api.openai.com/v1/chat/completions';
  static const String chatGPTModel = "gpt-3.5-turbo";
  static const Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials":
        'true', // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, DELETE",
    'Content-Type': 'application/json',
    'Accept': '*/*'
  };
}
