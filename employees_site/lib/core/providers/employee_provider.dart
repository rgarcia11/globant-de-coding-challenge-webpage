import 'dart:async';

import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/services/employee_service.dart';
import 'package:flutter/widgets.dart';

class EmployeeProvider extends ChangeNotifier {
  Map<int, Employee> employeesMap = {};
  List<Employee> employees = [];

  EmployeeProvider() {
    getAllEmployees();
  }

  Future<List<Employee>> getAllEmployees() async {
    employees = [];
    try {
      employees.addAll(await EmployeesService.getAllEmployees());
    } catch (error) {
      print('Error in employee_provder.getEmployees: $error');
    }

    setEmployees(employees);

    return employees;
  }

  Employee? getEmployeeById(int id) {
    return employeesMap[id];
  }

  void setEmployees(List<Employee> employees) {
    for (final employee in employees) {
      if (employee.id == null) {
        print('Got an employee with null ID at EmployeeProvider.setEmployees');
        continue;
      } else {
        employeesMap[employee.id!] = employee;
      }
    }
    notifyListeners();
  }

  void _terminate() async {
    employeesMap = {};
  }

  @override
  void dispose() {
    super.dispose();
    _terminate();
  }
}
