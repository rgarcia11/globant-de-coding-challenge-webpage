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
    final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/${JobsService.service}s'),
        headers: ApiConfig.headers);
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

  static Future<Job> createJob(Job newJob) async {
    final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/${JobsService.service}'),
        headers: ApiConfig.headers,
        body: jsonEncode(newJob.toJson()));

    final res = Job.fromJson(jsonDecode(response.body));
    return res;
  }
}
