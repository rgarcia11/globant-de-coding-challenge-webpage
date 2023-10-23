// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/services/api_config.dart';
import 'package:http/http.dart' as http;

class EmployeesService {
  static String service = 'employee';

  Future<http.Response> uploadEmployees() {
    // TODO: csv file
    return http.post(Uri.parse('${ApiConfig.baseUrl}/${service}s/upload'));
  }

  static Future<List<Employee>> getAllEmployees() async {
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
        Uri.parse('${ApiConfig.baseUrl}/${EmployeesService.service}s'),
        headers: headers);
    if (response.statusCode == 200) {
      final employees = jsonDecode(response.body);
      List<Employee> employeesList = [];
      for (dynamic employee in employees) {
        employeesList.add(Employee.fromJson(employee));
      }
      return employeesList;
    } else {
      return [];
    }
  }
}
