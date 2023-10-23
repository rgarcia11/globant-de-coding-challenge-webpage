import 'package:employees_site/core/models/employee_model.dart';
import 'package:employees_site/core/models/job_model.dart';
import 'package:flutter/material.dart';

class EntityCard extends StatelessWidget {
  final dynamic entity;
  const EntityCard({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: buildCardContent(),
    );
  }

  Widget buildCardContent() {
    if (entity == Employee) {
      return Text('Employee');
    } else {
      return Column(
        children: [
          Text(entity == Job ? entity.job : entity.department),
        ],
      );
    }
  }
}
