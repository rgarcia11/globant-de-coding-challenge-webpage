import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:employees_site/ui/screens/crud_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterForm extends StatefulWidget {
  final Entity activeEntity;
  const FilterForm({required this.activeEntity, super.key});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final TextEditingController _textFieldController = TextEditingController();
  bool _button1Hovered = false;

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
              const Text(
                'Enter filter',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (context.mounted) {
                        DepartmentProvider departmentProvider =
                            context.read<DepartmentProvider>();
                        EmployeeProvider employeeProvider =
                            context.read<EmployeeProvider>();
                        JobProvider jobProvider = context.read<JobProvider>();
                        if (widget.activeEntity == Entity.employees) {
                          employeeProvider
                              .filter(_textFieldController.text.trim());
                        } else if (widget.activeEntity == Entity.departments) {
                          departmentProvider
                              .filter(_textFieldController.text.trim());
                        } else if (widget.activeEntity == Entity.jobs) {
                          jobProvider.filter(_textFieldController.text.trim());
                        }
                        Navigator.of(context)
                            .pop<bool>(_textFieldController.text.isNotEmpty);
                      }
                    },
                    onHover: (value) {
                      setState(() {
                        _button1Hovered = value;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFFC0D731),
                      backgroundColor: _button1Hovered
                          ? const Color(0xFF8cc53f)
                          : const Color(0xFFC0D731),
                    ),
                    child: const Text(
                      'Filter',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
