import 'dart:async';
import 'dart:typed_data';

import 'package:employees_site/core/models/department_model.dart';
import 'package:employees_site/core/services/departments_service.dart';
import 'package:flutter/widgets.dart';

class DepartmentProvider extends ChangeNotifier {
  Map<int, Department> departmentsMap = {};
  List<Department> departments = [];
  List<Department> newDepartments = [];
  List<Department> filteredDepartments = [];

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
    filteredDepartments = departments;
    setDepartments(departments);
    notifyListeners();
    return departments;
  }

  Department? getDepartmentById(int id) {
    return departmentsMap[id];
  }

  void filter(String? term) {
    if (term == null || term.trim().isEmpty) {
      filteredDepartments = departments;
    } else {
      filteredDepartments = [];
      for (Department department in departments) {
        if (department.hasFilter(term)) {
          filteredDepartments.add(department);
        }
      }
    }
    notifyListeners();
  }

  Future<Department?> getDepartmentByName(String departmentName) async {
    for (Department department in departments) {
      if (department.department == departmentName) {
        return department;
      }
    }
    Department newDepartment = await DepartmentsService.createDepartment(
        Department(department: departmentName));
    departments = [newDepartment, ...departments];
    newDepartments.add(newDepartment);
    setDepartments([newDepartment]);
    notifyListeners();
    return newDepartment;
    // await getAllDepartments();
    // for (Department department in departments) {
    //   if (department.department == departmentName) {
    //     return department;
    //   }
    // }
    // return null;
  }

  Future<bool> uploadDepartments(Uint8List fileBytes) async {
    bool res = await DepartmentsService().uploadDepartments(fileBytes);
    if (res) {
      getAllDepartments();
    }
    return res;
  }

  Future<bool> deleteAllDepartments() async {
    bool res = await DepartmentsService.deleteAllDepartments();
    if (res) {
      getAllDepartments();
    }
    return res;
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

  Future<void> createDepartment(Department newDepartment) async {
    departments = [newDepartment, ...departments];
    newDepartments.add(newDepartment);
    setDepartments([newDepartment]);
    notifyListeners();
  }

  bool isANewDepartment(int departmentId) {
    return newDepartments.fold(false, (isANewDepartment, Department e) {
      if (isANewDepartment || e.id == departmentId) {
        return true;
      }
      return false;
    });
  }

  void deleteDepartment(int id) async {
    Department department = await DepartmentsService().deleteDepartment(id);
    departments.removeWhere((element) => element.id == department.id);
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
