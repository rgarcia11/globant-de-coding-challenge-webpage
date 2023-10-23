// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/services/api_config.dart';
import 'package:http/http.dart' as http;

class JobsService {
  static String service = 'job';

  Future<http.Response> uploadJobs() {
    // TODO: csv file
    return http.post(Uri.parse('${ApiConfig.baseUrl}/${service}s/upload'));
  }

  static Future<List<Job>> getAllJobs() async {
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          'true', // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, DELETE",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/${JobsService.service}s'),
        headers: headers);
    if (response.statusCode == 200) {
      final jobs = jsonDecode(response.body);
      List<Job> jobsList = [];
      for (dynamic job in jobs) {
        jobsList.add(Job.fromJson(job));
      }
      return jobsList;
    } else {
      return [];
    }
  }
}
