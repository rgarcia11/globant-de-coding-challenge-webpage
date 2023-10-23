// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:employees_site/core/models/department_model.dart';
import 'package:employees_site/core/services/api_config.dart';
import 'package:http/http.dart' as http;

class DepartmentsService {
  static String service = 'department';

  Future<http.Response> uploadDepartments() {
    // TODO: csv file
    return http.post(Uri.parse('${ApiConfig.baseUrl}/${service}s/upload'));
  }

  static Future<List<Department>> getAllDepartments() async {
    print('gato0');
    print(Uri.parse('${ApiConfig.baseUrl}/${DepartmentsService.service}s'));
    print('gato01');
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
        Uri.parse('${ApiConfig.baseUrl}/${DepartmentsService.service}s'),
        headers: headers);
    if (response.statusCode == 200) {
      print('gato1');
      final departments = jsonDecode(response.body);
      print('gato2');
      print(departments);
      List<Department> departmentsList = [];
      for (dynamic department in departments) {
        print('gato3');
        print(department);
        departmentsList.add(Department.fromJson(department));
      }
      print('gato4');
      print(departmentsList);
      return departmentsList;
    } else {
      return [];
    }
  }
}
