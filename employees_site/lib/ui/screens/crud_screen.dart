// ignore_for_file: unnecessary_string_interpolations

import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:employees_site/ui/widgets/challenge_app_bar.dart';
import 'package:employees_site/ui/widgets/entity_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Entity { departments, employees, jobs }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String trimLast() {
    return "${substring(0, length - 1)}";
  }
}

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  Entity _activeEntity = Entity.employees;
  bool _departmentsHovered = false;
  bool _employeesHovered = false;
  bool _jobsHovered = false;
  bool _loadCSVHovered = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double nonEmployeeAspectRatio = height < 890
        ? MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.8)
        : height < 600
            ? MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.8)
            : MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 3.2);
    double employeeAspectRatio = height < 850
        ? MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.1)
        : height < 760
            ? MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 0.1)
            : MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.25);
    return Scaffold(
      appBar: ChallengeAppBar(
        actions: [
          buildAction(entity: Entity.departments),
          buildAction(entity: Entity.jobs),
          buildAction(entity: Entity.employees),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_activeEntity.name.capitalize()}',
            style: const TextStyle(fontSize: 34.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CrudScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFE0E0E0),
                    ),
                    child: Text(
                      'Add ${_activeEntity.name}'.trimLast(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration:
                              _loadCSVHovered ? TextDecoration.underline : null,
                          decorationThickness: 2.0),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CrudScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFE0E0E0),
                    ),
                    child: Text(
                      'Find ${_activeEntity.name}'.trimLast(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration:
                              _loadCSVHovered ? TextDecoration.underline : null,
                          decorationThickness: 2.0),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CrudScreen()));
                },
                onHover: (value) {
                  setState(() {
                    _loadCSVHovered = value;
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFFC0D731),
                  backgroundColor:
                      _loadCSVHovered ? const Color(0xFFC0D731) : Colors.black,
                ),
                child: Text(
                  'load ${_activeEntity.name} CSV file',
                  style: TextStyle(
                      color: _loadCSVHovered
                          ? Colors.black
                          : const Color(0xFFC0D731),
                      fontWeight: FontWeight.bold,
                      decoration:
                          _loadCSVHovered ? TextDecoration.underline : null,
                      decorationThickness: 2.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: Consumer<EmployeeProvider>(
                builder: (context, employeeProvider, child) {
              return Consumer<DepartmentProvider>(
                  builder: (context, departmentProvider, child) {
                return Consumer<JobProvider>(
                  builder: (context, jobProvider, child) {
                    return GridView.builder(
                      // TODO: Bring the backend here
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 32.0,
                        mainAxisSpacing: 30.0,
                        childAspectRatio: _activeEntity == Entity.employees
                            ? employeeAspectRatio
                            : nonEmployeeAspectRatio,
                      ),
                      itemCount: _activeEntity == Entity.departments
                          ? departmentProvider.departments.length
                          : _activeEntity == Entity.jobs
                              ? jobProvider.jobs.length
                              : employeeProvider.employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EntityCard(
                          entity: getEntity(index),
                        );
                      },
                    );
                  },
                );
              });
            }),
          ),
        ],
      ),
    );
  }

  dynamic getEntity(int index) {
    DepartmentProvider departmentProvider = context.read<DepartmentProvider>();
    JobProvider jobProvider = context.read<JobProvider>();
    EmployeeProvider employeeProvider = context.read<EmployeeProvider>();
    if (_activeEntity == Entity.departments) {
      return departmentProvider.departments[index];
    } else if (_activeEntity == Entity.jobs) {
      return jobProvider.jobs[index];
    } else {
      return employeeProvider.employees[index];
    }
  }

  Widget buildAction({required Entity entity}) {
    return TextButton(
      onPressed: () {
        setState(() {
          _activeEntity = entity;
        });
      },
      onHover: (value) {
        setState(() {
          if (entity == Entity.departments) {
            _departmentsHovered = value;
          } else if (entity == Entity.employees) {
            _employeesHovered = value;
          } else if (entity == Entity.jobs) {
            _jobsHovered = value;
          }
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      child: Text(
        '${entity.name.capitalize()}',
        style: TextStyle(
          fontWeight:
              entity == _activeEntity ? FontWeight.bold : FontWeight.normal,
          shadows: const [Shadow(color: Colors.black, offset: Offset(0, -5.0))],
          color: Colors.transparent,
          decoration: entity == _activeEntity
              ? TextDecoration.underline
              : entity == Entity.departments && _departmentsHovered
                  ? TextDecoration.underline
                  : entity == Entity.jobs && _jobsHovered
                      ? TextDecoration.underline
                      : entity == Entity.employees && _employeesHovered
                          ? TextDecoration.underline
                          : null,
          decorationColor: Colors.black,
          decorationThickness: 2.0,
        ),
      ),
    );
  }
}
