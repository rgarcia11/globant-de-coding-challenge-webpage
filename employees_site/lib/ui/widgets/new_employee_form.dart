import 'dart:convert';

import 'package:employees_site/core/models/department_model.dart';
import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:employees_site/core/services/chatgpt_service.dart';
import 'package:employees_site/core/services/employee_service.dart';
import 'package:employees_site/ui/screens/crud_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEmployeeForm extends StatefulWidget {
  final bool landing;
  const NewEmployeeForm({this.landing = false, super.key});

  @override
  State<NewEmployeeForm> createState() => _NewEmployeeFormState();
}

class _NewEmployeeFormState extends State<NewEmployeeForm> {
  final TextEditingController _textFieldController = TextEditingController();
  bool _buttonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 570.0,
      height: 420,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(45.0, 50.0, 45.0, 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text:
                          'Tell us your name and your dream job. Include which one of our departments you want',
                      style: TextStyle(
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(0, -5.0))
                        ],
                        color: Colors.transparent,
                      ),
                    ),
                    TextSpan(
                      text: ' to be a part of',
                      style: TextStyle(
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(0, -5.0))
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFa0f4a4),
                        decorationThickness: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: _textFieldController,
                maxLines: 6,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0E0E0E),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22.0),
              ElevatedButton(
                onPressed: () async {
                  String? answer =
                      await newUserChatGPT(_textFieldController.text);
                  if (answer == null) {
                    // TODO: Inform user
                  } else {
                    if (context.mounted) {
                      Map<String, dynamic> newEmployee = jsonDecode(answer);
                      // TODO: Look for department id and job id to complete it
                      DepartmentProvider departmentProvider =
                          context.read<DepartmentProvider>();
                      JobProvider jobProvider = context.read<JobProvider>();
                      EmployeeProvider employeeProvider =
                          context.read<EmployeeProvider>();
                      Job? job =
                          await jobProvider.getJobByName(newEmployee['job']);
                      Department? department = await departmentProvider
                          .getDepartmentByName(newEmployee['department']);
                      newEmployee.addAll(
                          {"department_id": department!.id, "job_id": job!.id});
                      newEmployee.remove('department');
                      newEmployee.remove('job');
                      Employee createdEmployee =
                          await EmployeesService.createEmployee(
                              Employee.fromJson(newEmployee));
                      employeeProvider.hireEmployee(createdEmployee);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CrudScreen()));
                    }
                  }
                },
                onHover: (value) {
                  setState(() {
                    _buttonHovered = value;
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFFC0D731),
                  backgroundColor: _buttonHovered
                      ? const Color(0xFF8cc53f)
                      : const Color(0xFFC0D731),
                ),
                child: const Text(
                  'START REINVENTING',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
