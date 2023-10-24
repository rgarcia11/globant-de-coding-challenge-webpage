import 'dart:async';

import 'package:employees_site/core/models/department_model.dart';
import 'package:employees_site/core/services/departments_service.dart';
import 'package:flutter/widgets.dart';

class DepartmentProvider extends ChangeNotifier {
  Map<int, Department> departmentsMap = {};
  List<Department> departments = [];

  DepartmentProvider() {
    getAllDepartments();
  }

  Future<List<Department>> getAllDepartments() async {
    departments = [];
    try {
      departments.addAll(await DepartmentsService.getAllDepartments());
    } catch (error) {
      print('Error in department_provder.getDepartments: $error');
    }

    setDepartments(departments);

    return departments;
  }

  Department? getDepartmentById(int id) {
    return departmentsMap[id];
  }

  Future<Department?> getDepartmentByName(String departmentName) async {
    for (Department department in departments) {
      if (department.department == departmentName) {
        return department;
      }
    }
    await DepartmentsService.createDepartment(
        Department(department: departmentName));
    await getAllDepartments();
    for (Department department in departments) {
      if (department.department == departmentName) {
        return department;
      }
    }
    return null;
  }

  void setDepartments(List<Department> departments) {
    for (final department in departments) {
      if (department.id == null) {
        print(
            'Got an department with null ID at DepartmentProvider.setDepartments');
        continue;
      } else {
        departmentsMap[department.id!] = department;
      }
    }
    notifyListeners();
  }

  void _terminate() async {
    departmentsMap = {};
  }

  @override
  void dispose() {
    super.dispose();
    _terminate();
  }
}
