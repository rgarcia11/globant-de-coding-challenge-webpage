import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/models/job_model.dart';
import 'package:flutter/material.dart';

class EntityCard extends StatelessWidget {
  final dynamic entity;
  const EntityCard({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 35.0, bottom: 28.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 4.0, color: Color(0xFFC0D731)),
          right: BorderSide(width: 0.0, color: Color(0xFFC0D731)),
          bottom: BorderSide(width: 0.0, color: Color(0xFFC0D731)),
          left: BorderSide(width: 0.0, color: Color(0xFFC0D731)),
        ),
        boxShadow: [
          BoxShadow(
              color: Color(0xFFE0E0E0), spreadRadius: 1.0, blurRadius: 0.0)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.zero,
      ),
      height: entity == Employee ? 520 : 320,
      child: Align(alignment: Alignment.bottomLeft, child: buildCardContent()),
    );
  }

  Widget buildCardContent() {
    List<Widget> columnContent = [];
    if (entity is Employee) {
      columnContent.addAll([
        Text(
          entity.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Row(children: [
          const Icon(Icons.corporate_fare),
          Text('${entity.departmentId}')
        ]),
        Row(children: [const Icon(Icons.work), Text('${entity.jobId}')]),
        Text('Since ${entity.datetime}'),
      ]);
    } else {
      if (entity is Job) {}
      return Column(
        children: [
          Text(entity is Job ? entity.job : entity.department),
        ],
      );
    }
    columnContent.addAll([
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
          surfaceTintColor: Colors.transparent,
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
            Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
          ],
        ),
      ) // TODO: Copy format from other flat buttons
    ]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnContent,
    );
  }
}
