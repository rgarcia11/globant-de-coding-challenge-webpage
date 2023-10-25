import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntityCard extends StatelessWidget {
  final dynamic entity;
  const EntityCard({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    EmployeeProvider employeeProvider = context.read<EmployeeProvider>();
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20.0, top: 35.0, bottom: 28.0),
          decoration: BoxDecoration(
            border: const Border(
              top: BorderSide(width: 4.0, color: Color(0xFFC0D731)),
              right: BorderSide(width: 0.0, color: Color(0xFFC0D731)),
              bottom: BorderSide(width: 0.0, color: Color(0xFFC0D731)),
              left: BorderSide(width: 0.0, color: Color(0xFFC0D731)),
            ),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xFFE0E0E0), spreadRadius: 1.0, blurRadius: 0.0)
            ],
            color: entity is Employee
                ? employeeProvider.isANewHire(entity.id)
                    ? const Color(0xFFC0D731)
                    : Colors.white
                : Colors.white,
            borderRadius: BorderRadius.zero,
          ),
          child:
              Align(alignment: Alignment.bottomLeft, child: buildCardContent()),
        ),
        entity is Employee
            ? employeeProvider.isANewHire(entity.id)
                ? Positioned(
                    top: -5.0,
                    right: 15.0,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1.0,
                              blurRadius: 5.0,
                              color: Colors.grey,
                              offset: Offset(0, 5))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: const Text('NEW'),
                    ),
                  )
                : Container()
            : Container(),
      ],
    );
  }

  Widget buildCardContent() {
    List<Widget> columnContent = [];
    if (entity is Employee) {
      columnContent.addAll(
        [
          Text(
            entity.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.corporate_fare),
              const SizedBox(width: 5.0),
              Consumer<DepartmentProvider>(
                builder: (context, departmentProvider, child) {
                  String departmentName = departmentProvider
                      .getDepartmentById(entity.departmentId)!
                      .department;
                  return Text(departmentName);
                },
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.work),
              const SizedBox(width: 5.0),
              Consumer<JobProvider>(
                builder: (context, jobProvider, child) {
                  String jobName = jobProvider.getJobById(entity.jobId)!.job;
                  return Text(jobName);
                },
              )
            ],
          ),
          Text('Since ${entity.datetime}'),
        ],
      );
    } else {
      columnContent.addAll(
        [
          Column(
            children: [
              Row(
                children: [
                  Icon(entity is Job ? Icons.work : Icons.corporate_fare),
                  const SizedBox(width: 5.0),
                  Text(entity is Job ? entity.job : entity.department),
                ],
              ),
            ],
          ),
        ],
      );
    }
    columnContent.addAll(
      [
        const Text(
          'Five ch',
          style: TextStyle(
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationThickness: 1.5),
        ),
        TextButton(
          onPressed: () {
            // TODO: Enter edit form
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0.0),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
          ),
          child: const Row(
            children: [
              Text(
                'See details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(width: 5.0),
              Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnContent,
    );
  }
}
