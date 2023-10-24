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
    final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/${DepartmentsService.service}s'),
        headers: ApiConfig.headers);
    if (response.statusCode == 200) {
      final departments = jsonDecode(response.body);
      List<Department> departmentsList = [];
      for (dynamic department in departments) {
        departmentsList.add(Department.fromJson(department));
      }
      return departmentsList;
    } else {
      return [];
    }
  }

  static Future<Department> createDepartment(Department newDepartment) async {
    final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/${DepartmentsService.service}'),
        headers: ApiConfig.headers,
        body: jsonEncode(newDepartment.toJson()));

    final res = Department.fromJson(jsonDecode(response.body));
    return res;
  }
}
