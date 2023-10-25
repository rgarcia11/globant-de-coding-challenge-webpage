// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:employees_site/core/models/department_model.dart';
import 'package:employees_site/core/services/api_config.dart';
import 'package:http/http.dart' as http;

class DepartmentsService {
  static String service = 'department';
  final dio = Dio();

  Future<List> departmentsOverHiringMean(String year) async {
    Response res = await dio.get(
        '${ApiConfig.baseUrl}/${DepartmentsService.service}s/over_hiring_mean',
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

  Future<bool> uploadDepartments(Uint8List fileBytes) async {
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
        '${ApiConfig.baseUrl}/${DepartmentsService.service}s/upload',
        data: formData);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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

  static Future<bool> deleteAllDepartments() async {
    final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/${DepartmentsService.service}s'),
        headers: ApiConfig.headers);
    return response.statusCode == 200;
  }

  Future<Department> deleteDepartment(int id) async {
    Response res = await dio.delete(
        '${ApiConfig.baseUrl}/${DepartmentsService.service}',
        queryParameters: {"id": id});
    if (res.statusCode == 200) {
      return Department.fromJson(res.data);
    }
    throw Exception("This should never come here");
  }
}
