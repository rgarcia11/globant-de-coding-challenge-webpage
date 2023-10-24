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
    final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/${EmployeesService.service}s'),
        headers: ApiConfig.headers);
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

  static Future<String> createEmployee(Employee newEmployee) async {
    final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/${EmployeesService.service}'),
        headers: ApiConfig.headers,
        body: jsonEncode(newEmployee.toJson()));

    final res = jsonDecode(response.body);
    return res;
  }
}
