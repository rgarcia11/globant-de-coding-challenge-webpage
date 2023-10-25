import 'dart:async';
import 'dart:typed_data';

import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/services/employee_service.dart';
import 'package:flutter/widgets.dart';

class EmployeeProvider extends ChangeNotifier {
  Map<int, Employee> employeesMap = {};
  List<Employee> employees = [];
  List<Employee> hiredEmployees = [];
  List<Employee> filteredEmployees = [];

  EmployeeProvider() {
    getAllEmployees();
  }

  Future<List<Employee>> getAllEmployees() async {
    employees = [];
    try {
      List<Employee> employeeList = await EmployeesService.getAllEmployees();
      employees.addAll(employeeList);
    } catch (error) {
      print('Error in employee_provder.getEmployees: $error');
    }
    filteredEmployees = employees;
    sortEmployees();
    setEmployees(employees);
    notifyListeners();
    return employees;
  }

  Employee? getEmployeeById(int id) {
    return employeesMap[id];
  }

  Future<bool> uploadEmployees(Uint8List fileBytes) async {
    bool res = await EmployeesService().uploadEmployees(fileBytes);
    if (res) {
      getAllEmployees();
      return true;
    }
    return false;
  }

  Future<bool> deleteAllEmployees() async {
    bool res = await EmployeesService.deleteAllEmployees();
    if (res) {
      getAllEmployees();
    }
    return res;
  }

  void hireEmployee(Employee newEmployee) {
    employees = [newEmployee, ...employees];
    filteredEmployees = [newEmployee, ...filteredEmployees];
    hiredEmployees.add(newEmployee);
    setEmployees([newEmployee]);
    notifyListeners();
  }

  void filter(String? term) {
    if (term == null || term.trim().isEmpty) {
      filteredEmployees = employees;
    } else {
      filteredEmployees = [];
      for (Employee employee in employees) {
        if (employee.hasFilter(term)) {
          filteredEmployees.add(employee);
        }
      }
    }
    notifyListeners();
  }

  bool isANewHire(int employeeId) {
    return hiredEmployees.fold(false, (isNewHire, Employee e) {
      if (isNewHire || e.id == employeeId) {
        return true;
      }
      return false;
    });
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

  void sortEmployees() {
    employees.sort(
      (Employee a, Employee b) {
        DateTime adate = a.datetime;
        DateTime bdate = b.datetime;
        return bdate.compareTo(adate);
      },
    );
  }

  void deleteEmployee(int id) async {
    Employee employee = await EmployeesService().deleteEmployee(id);
    employees.removeWhere((element) => element.id == employee.id);
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
