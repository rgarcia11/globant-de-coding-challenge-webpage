// ignore_for_file: unnecessary_string_interpolations

import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:employees_site/core/services/departments_service.dart';
import 'package:employees_site/core/services/employee_service.dart';
import 'package:employees_site/ui/widgets/add_form.dart';
import 'package:employees_site/ui/widgets/challenge_app_bar.dart';
import 'package:employees_site/ui/widgets/entity_card.dart';
import 'package:employees_site/ui/widgets/filter_form.dart';
import 'package:file_picker/file_picker.dart';
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
  bool _addHovered = false;
  bool _filterHovered = false;
  bool _deleteHovered = false;
  bool _employeesHiredHovered = false;
  bool _departmentsOverMeanHovered = false;
  bool _departmentsActiveFilter = false;
  bool _jobsActiveFilter = false;
  bool _employeesActiveFilter = false;
  double pagePadding = 140.0;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    if (width > 1250) {
      padding = 140.0;
    } else if (width > 670) {
      padding = 100;
    } else {
      padding = 10.0;
    }

    return Scaffold(
      appBar: ChallengeAppBar(
        actions: [
          buildAction(entity: Entity.departments),
          buildAction(entity: Entity.jobs),
          buildAction(entity: Entity.employees),
        ],
      ),
      body: Consumer<EmployeeProvider>(
          builder: (context, employeeProvider, child) {
        return Consumer<DepartmentProvider>(
            builder: (context, departmentProvider, child) {
          return Consumer<JobProvider>(builder: (context, jobProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Image.asset('assets/banner.png'),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 50.0),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            '${_activeEntity.name.capitalize()}',
                            style: const TextStyle(
                                fontSize: 34.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 50.0),
                      ),
                      buildCRUDButtonTray(context),
                      const SliverToBoxAdapter(child: SizedBox(height: 90.0)),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width > 1250.0
                                ? 140.0
                                : width > 670
                                    ? 100.0
                                    : 10.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 210.0,
                            crossAxisCount: width > 1250 ? 3 : 2,
                            crossAxisSpacing: 32.0,
                            mainAxisSpacing: 30.0,
                            // childAspectRatio: _activeEntity == Entity.employees
                            //     ? employeeAspectRatio
                            //     : nonEmployeeAspectRatio,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: _activeEntity == Entity.departments
                                ? departmentProvider.filteredDepartments.length
                                : _activeEntity == Entity.jobs
                                    ? jobProvider.filteredJobs.length
                                    : employeeProvider.filteredEmployees.length,
                            (context, index) {
                              //   itemCount: _activeEntity == Entity.departments
                              //     ? departmentProvider.departments.length
                              //     : _activeEntity == Entity.jobs
                              //         ? jobProvider.jobs.length
                              //         : employeeProvider.employees.length,
                              // itemBuilder: (BuildContext context, int index) {
                              return EntityCard(
                                entity: getEntity(index),
                              );
                            },
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 260.0),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                            height: 260.0, color: const Color(0xFF121212)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        });
      }),
    );
  }

  dynamic getEntity(int index) {
    DepartmentProvider departmentProvider = context.read<DepartmentProvider>();
    JobProvider jobProvider = context.read<JobProvider>();
    EmployeeProvider employeeProvider = context.read<EmployeeProvider>();
    if (_activeEntity == Entity.departments) {
      return departmentProvider.filteredDepartments[index];
    } else if (_activeEntity == Entity.jobs) {
      return jobProvider.filteredJobs[index];
    } else {
      return employeeProvider.filteredEmployees[index];
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

  dynamic buildCRUDButtonTray(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    List<Widget> firstTray = [
      buildFilterButton(),
      SizedBox(width: width > 670 ? 20.0 : 5.0),
      buildAddButton(),
      SizedBox(width: width > 670 ? 20.0 : 5.0),
      buildDeleteButton(),
    ];
    List<Widget> secondTray = [
      _activeEntity == Entity.employees
          ? buildEmployeesByQuarterButton()
          : Container(),
      _activeEntity == Entity.departments
          ? buildDepartmentsOverMeanButton()
          : Container(),
      _activeEntity == Entity.jobs
          ? Container()
          : SizedBox(width: width > 670 ? 20.0 : 5.0),
      buildLoadCSVButton(),
    ];
    if (width > 1250) {
      padding = 140.0;
    } else if (width > 670) {
      padding = 100;
    } else {
      padding = 10.0;
    }
    return Builder(
      builder: (context) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: SliverToBoxAdapter(
            child: width > 1250
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: firstTray,
                      ),
                      Row(
                        children: secondTray,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: firstTray,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: secondTray,
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }

  void showAddDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Container(
              width: 500.0,
              height: 380.0,
              color: Colors.white,
              child: AddForm(
                activeEntity: _activeEntity,
              ),
            ));
      },
    );
  }

  void showFilterDialog() {
    showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Container(
              width: 500.0,
              height: 380.0,
              color: Colors.white,
              child: FilterForm(
                activeEntity: _activeEntity,
              ),
            ));
      },
    ).then((bool? value) {
      if (value != null && value) {
        if (_activeEntity == Entity.departments) {
          _departmentsActiveFilter = value;
        } else if (_activeEntity == Entity.employees) {
          _employeesActiveFilter = value;
        } else if (_activeEntity == Entity.jobs) {
          _jobsActiveFilter = value;
        }
      }
    });
  }

  void showResultDialog(List table) {
    List<Widget> headerRowWidgets = [];
    if (_activeEntity == Entity.employees) {
      headerRowWidgets.addAll([
        const Center(child: Text('Department')),
        const Center(child: Text('Job')),
        const Center(child: Text('Q1')),
        const Center(child: Text('Q2')),
        const Center(child: Text('Q3')),
        const Center(child: Text('Q4'))
      ]);
    } else if (_activeEntity == Entity.departments) {
      headerRowWidgets.addAll([
        const Center(child: Text('Id')),
        const Center(child: Text('Department')),
        const Center(child: Text('Hired')),
      ]);
    }
    TableRow headerRow = TableRow(children: headerRowWidgets);
    List<TableRow> tableRows = [];
    for (List row in table) {
      List<Widget> widgets = [];
      for (dynamic columnVal in row) {
        Widget widget = Center(child: Text('$columnVal'));
        widgets.add(widget);
      }
      tableRows.add(TableRow(children: widgets));
    }
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Container(
            width: 500.0,
            height: 500.0,
            color: Colors.white,
            child: Table(
                border: TableBorder.all(color: Colors.black),
                children: [headerRow, ...tableRows]),
          ),
        );
      },
    );
  }

  Widget buildFilterButton() {
    DepartmentProvider departmentProvider = context.read<DepartmentProvider>();
    EmployeeProvider employeesProvider = context.read<EmployeeProvider>();
    JobProvider jobsProvider = context.read<JobProvider>();
    return ElevatedButton(
      onPressed: () {
        if (_activeEntity == Entity.departments) {
          if (_departmentsActiveFilter) {
            departmentProvider.filter('');
            _departmentsActiveFilter = false;
          } else {
            showFilterDialog();
          }
        } else if (_activeEntity == Entity.employees) {
          if (_employeesActiveFilter) {
            employeesProvider.filter('');
            _employeesActiveFilter = false;
          } else {
            showFilterDialog();
          }
        }
        if (_activeEntity == Entity.jobs) {
          if (_jobsActiveFilter) {
            jobsProvider.filter('');
            _jobsActiveFilter = false;
          } else {
            showFilterDialog();
          }
        }
      },
      onHover: (value) {
        setState(() {
          _filterHovered = value;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor:
            _activeEntity == Entity.departments && _departmentsActiveFilter
                ? Colors.white
                : _activeEntity == Entity.employees && _employeesActiveFilter
                    ? Colors.white
                    : _activeEntity == Entity.jobs && _jobsActiveFilter
                        ? Colors.white
                        : Colors.black,
        backgroundColor:
            _activeEntity == Entity.departments && _departmentsActiveFilter
                ? Colors.black
                : _activeEntity == Entity.employees && _employeesActiveFilter
                    ? Colors.black
                    : _activeEntity == Entity.jobs && _jobsActiveFilter
                        ? Colors.black
                        : const Color(0xFFE0E0E0),
      ),
      child: Text(
        'Filter',
        style: TextStyle(
          color: _activeEntity == Entity.departments && _departmentsActiveFilter
              ? Colors.white
              : _activeEntity == Entity.employees && _employeesActiveFilter
                  ? Colors.white
                  : _activeEntity == Entity.jobs && _jobsActiveFilter
                      ? Colors.white
                      : Colors.black,
          fontWeight: FontWeight.bold,
          decoration: _filterHovered ? TextDecoration.underline : null,
          decorationThickness: 2.0,
          decorationColor:
              _activeEntity == Entity.departments && _departmentsActiveFilter
                  ? Colors.white
                  : _activeEntity == Entity.employees && _employeesActiveFilter
                      ? Colors.white
                      : _activeEntity == Entity.jobs && _jobsActiveFilter
                          ? Colors.white
                          : Colors.black,
        ),
      ),
    );
  }

  Widget buildAddButton() {
    return ElevatedButton(
      onPressed: () {
        showAddDialog();
      },
      onHover: (value) {
        setState(() {
          _addHovered = value;
        });
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
            decoration: _addHovered ? TextDecoration.underline : null,
            decorationThickness: 2.0),
      ),
    );
  }

  Widget buildDeleteButton() {
    EmployeeProvider employeeProvider = context.read<EmployeeProvider>();
    DepartmentProvider departmentProvider = context.read<DepartmentProvider>();
    JobProvider jobProvider = context.read<JobProvider>();
    return ElevatedButton(
      onPressed: () {
        if (_activeEntity == Entity.employees) {
          employeeProvider.deleteAllEmployees();
        } else if (_activeEntity == Entity.departments) {
          departmentProvider.deleteAllDepartments();
        } else if (_activeEntity == Entity.jobs) {
          jobProvider.deleteAllJobs();
        }
      },
      onHover: (value) {
        setState(() {
          _deleteHovered = value;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFE0E0E0),
      ),
      child: Text(
        'Delete all ${_activeEntity.name}s'.trimLast(),
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            decoration: _deleteHovered ? TextDecoration.underline : null,
            decorationThickness: 2.0),
      ),
    );
  }

  Widget buildEmployeesByQuarterButton() {
    return ElevatedButton(
      onPressed: () async {
        List employeesHiredByQuarter =
            await EmployeesService().employeesHiredByQuarter("2021");
        if (employeesHiredByQuarter.isNotEmpty) {
          showResultDialog(employeesHiredByQuarter);
        }
      },
      onHover: (value) {
        setState(() {
          _employeesHiredHovered = value;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFFC0D731),
        backgroundColor:
            _employeesHiredHovered ? const Color(0xFFC0D731) : Colors.black,
      ),
      child: Text(
        'Employees Hired by Quarter',
        style: TextStyle(
            color:
                _employeesHiredHovered ? Colors.black : const Color(0xFFC0D731),
            fontWeight: FontWeight.bold,
            decoration:
                _departmentsOverMeanHovered ? TextDecoration.underline : null,
            decorationThickness: 2.0),
      ),
    );
  }

  Widget buildDepartmentsOverMeanButton() {
    return ElevatedButton(
      onPressed: () async {
        List departmentsOverHiringMeaan =
            await DepartmentsService().departmentsOverHiringMean("2021");
        if (departmentsOverHiringMeaan.isNotEmpty) {
          showResultDialog(departmentsOverHiringMeaan);
        }
      },
      onHover: (value) {
        setState(() {
          _departmentsOverMeanHovered = value;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFFC0D731),
        backgroundColor: _departmentsOverMeanHovered
            ? const Color(0xFFC0D731)
            : Colors.black,
      ),
      child: Text(
        'Departments Over Hiring Mean',
        style: TextStyle(
            color: _departmentsOverMeanHovered
                ? Colors.black
                : const Color(0xFFC0D731),
            fontWeight: FontWeight.bold,
            decoration:
                _departmentsOverMeanHovered ? TextDecoration.underline : null,
            decorationThickness: 2.0),
      ),
    );
  }

  Widget buildLoadCSVButton() {
    EmployeeProvider employeeProvider = context.read<EmployeeProvider>();
    DepartmentProvider departmentProvider = context.read<DepartmentProvider>();
    JobProvider jobProvider = context.read<JobProvider>();
    return ElevatedButton(
      onPressed: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          final fileBytes = result.files.single.bytes;
          if (_activeEntity == Entity.departments) {
            departmentProvider.uploadDepartments(fileBytes!);
          } else if (_activeEntity == Entity.employees) {
            employeeProvider.uploadEmployees(fileBytes!);
          } else if (_activeEntity == Entity.jobs) {
            jobProvider.uploadJobs(fileBytes!);
          }
        }
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
        'Load ${_activeEntity.name.capitalize()} CSV File',
        style: TextStyle(
            color: _loadCSVHovered ? Colors.black : const Color(0xFFC0D731),
            fontWeight: FontWeight.bold,
            decoration: _loadCSVHovered ? TextDecoration.underline : null,
            decorationThickness: 2.0),
      ),
    );
  }
}
