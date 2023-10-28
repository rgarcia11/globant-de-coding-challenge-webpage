import 'dart:convert';

import 'package:employees_site/core/models/department_model.dart';
import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:employees_site/core/services/chatgpt_service.dart';
import 'package:employees_site/core/services/departments_service.dart';
import 'package:employees_site/core/services/employee_service.dart';
import 'package:employees_site/core/services/jobs_service.dart';
import 'package:employees_site/ui/screens/crud_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddForm extends StatefulWidget {
  final Entity activeEntity;
  const AddForm({required this.activeEntity, super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final TextEditingController _textFieldController = TextEditingController();
  bool _buttonHovered = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              const Text('Enter info'),
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
                  focusedBorder: OutlineInputBorder(
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
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        content: Container(
                          width: 260.0,
                          height: 260.0,
                          color: Colors.white,
                          child: const CircularProgressIndicator(
                              color: Color(0xFFa0f4a4),
                              backgroundColor: Colors.white,
                              strokeWidth: 5.0),
                        ),
                      );
                    },
                  );
                  String? answer;
                  if (context.mounted) {
                    ChatGPTService chatGPTService = ChatGPTService();
                    if (widget.activeEntity == Entity.employees) {
                      answer = await chatGPTService
                          .addEmployeeChatGPT(_textFieldController.text);
                    } else if (widget.activeEntity == Entity.departments) {
                      answer = await chatGPTService
                          .addDepartmentChatGPT(_textFieldController.text);
                    } else if (widget.activeEntity == Entity.jobs) {
                      answer = await chatGPTService
                          .addJobChatGPT(_textFieldController.text);
                    }

                    DepartmentProvider departmentProvider =
                        context.read<DepartmentProvider>();
                    EmployeeProvider employeeProvider =
                        context.read<EmployeeProvider>();
                    JobProvider jobProvider = context.read<JobProvider>();
                    if (answer == null) {
                      Navigator.of(context).pop();
                    } else {
                      if (widget.activeEntity == Entity.employees) {
                        Map<String, dynamic> newEmployee = jsonDecode(answer);
                        Job? job =
                            await jobProvider.getJobByName(newEmployee['job']);
                        Department? department = await departmentProvider
                            .getDepartmentByName(newEmployee['department']);
                        newEmployee.addAll({
                          "department_id": department!.id,
                          "job_id": job!.id
                        });
                        newEmployee.remove('department');
                        newEmployee.remove('job');
                        Employee createdEmployee =
                            await EmployeesService.createEmployee(
                                Employee.fromJson(newEmployee));
                        employeeProvider.hireEmployee(createdEmployee);
                      } else if (widget.activeEntity == Entity.departments) {
                        Map<String, dynamic> newDepartment = jsonDecode(answer);
                        Department createdDepartment =
                            await DepartmentsService.createDepartment(
                                Department.fromJson(newDepartment));
                        departmentProvider.createDepartment(createdDepartment);
                      } else if (widget.activeEntity == Entity.jobs) {
                        Map<String, dynamic> newJob = jsonDecode(answer);
                        Job createdJob =
                            await JobsService.createJob(Job.fromJson(newJob));
                        jobProvider.createJob(createdJob);
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
                  'Add',
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
