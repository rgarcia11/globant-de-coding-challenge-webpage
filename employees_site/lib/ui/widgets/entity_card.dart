import 'package:employees_site/core/models/department_model.dart';
import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/models/job_model.dart';
import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EntityCard extends StatelessWidget {
  final dynamic entity;
  const EntityCard({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    EmployeeProvider employeeProvider = context.read<EmployeeProvider>();
    DepartmentProvider departmentProvider = context.read<DepartmentProvider>();
    JobProvider jobProvider = context.read<JobProvider>();
    Widget? tag;
    if (entity is Employee && employeeProvider.isANewHire(entity.id) ||
        entity is Department &&
            departmentProvider.isANewDepartment(entity.id) ||
        entity is Job && jobProvider.isANewJob(entity.id)) {
      tag = Positioned(
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
      );
    } else {
      tag = Container();
    }
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
                : entity is Department
                    ? departmentProvider.isANewDepartment(entity.id)
                        ? const Color(0xFFC0D731)
                        : Colors.white
                    : entity is Job
                        ? jobProvider.isANewJob(entity.id)
                            ? const Color(0xFFC0D731)
                            : Colors.white
                        : Colors.white,
            borderRadius: BorderRadius.zero,
          ),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: buildCardContent(context)),
        ),
        tag
      ],
    );
  }

  Widget buildCardContent(BuildContext context) {
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
                  String? departmentName = departmentProvider
                      .getDepartmentById(entity.departmentId)
                      ?.department;
                  return Text(departmentName ?? '${entity.departmentId}');
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
                  String? jobName = jobProvider.getJobById(entity.jobId)?.job;
                  return Text(jobName ?? '${entity.jobId}');
                },
              )
            ],
          ),
          Text('Since ${DateFormat('yyyy-MM-dd').format(entity.datetime)}'),
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
        SizedBox(height: 5.0),
        InkWell(
          onTap: () {
            EmployeeProvider employeeProvider =
                context.read<EmployeeProvider>();
            DepartmentProvider departmentProvider =
                context.read<DepartmentProvider>();
            JobProvider jobProvider = context.read<JobProvider>();

            if (entity is Employee) {
              employeeProvider.deleteEmployee(entity.id);
            } else if (entity is Department) {
              departmentProvider.deleteDepartment(entity.id);
            } else if (entity is Job) {
              jobProvider.deleteJob(entity.id);
            }
          },
          child: const Row(
            children: [
              Text(
                'Remove',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(width: 5.0),
              Icon(
                Icons.close,
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
