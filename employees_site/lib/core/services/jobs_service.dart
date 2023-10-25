// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/services/api_config.dart';
import 'package:http/http.dart' as http;

class JobsService {
  static String service = 'job';
  final dio = Dio();

  Future<bool> uploadJobs(Uint8List fileBytes) async {
    FormData formData = FormData.fromMap(
      {
        "csv_header_row": false,
        "batch_size": 1000,
        "csv_file":
            MultipartFile.fromBytes(fileBytes, filename: "csv_file.csv"),
      },
    );
    dio.options.headers['content-Type'] = 'multipart/form-data';

    Response res = await dio.post(
        '${ApiConfig.baseUrl}/${JobsService.service}s/upload',
        data: formData);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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

  static Future<bool> deleteAllJobs() async {
    final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/${JobsService.service}s'),
        headers: ApiConfig.headers);
    return response.statusCode == 200;
  }
}
