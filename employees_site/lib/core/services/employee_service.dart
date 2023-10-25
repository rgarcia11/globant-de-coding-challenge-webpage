// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/services/api_config.dart';
import 'package:http/http.dart' as http;

class EmployeesService {
  static String service = 'employee';
  final dio = Dio();

  Future<List> employeesHiredByQuarter(String year) async {
    Response res = await dio.get(
        '${ApiConfig.baseUrl}/${EmployeesService.service}s/hired_by_quarter',
        queryParameters: {"year": year});
    try {
      final data = jsonDecode(res.data);
      List responseTable = [];
      for (dynamic row in data) {
        List responseRow = [];
        for (dynamic column in row) {
          responseRow.add(column);
        }
        responseTable.add(responseRow);
      }
      return responseTable;
    } on Exception {
      return [];
    }
  }

  Future<bool> uploadEmployees(Uint8List fileBytes) async {
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
        '${ApiConfig.baseUrl}/${EmployeesService.service}s/upload',
        data: formData);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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

  static Future<Employee> createEmployee(Employee newEmployee) async {
    final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/${EmployeesService.service}'),
        headers: ApiConfig.headers,
        body: jsonEncode(newEmployee.toJson()));

    final res = Employee.fromJson(jsonDecode(response.body));
    return res;
  }

  static Future<bool> deleteAllEmployees() async {
    final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/${EmployeesService.service}s'),
        headers: ApiConfig.headers);
    return response.statusCode == 200;
  }
}
