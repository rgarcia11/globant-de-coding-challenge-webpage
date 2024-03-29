import 'package:employees_site/core/providers/department_provider.dart';
import 'package:employees_site/core/providers/employee_provider.dart';
import 'package:employees_site/core/providers/job_provider.dart';
import 'package:employees_site/ui/widgets/challenge_app_bar.dart';
import 'package:employees_site/ui/widgets/hire_employee_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeLandingScreen extends StatefulWidget {
  const ChallengeLandingScreen({super.key});

  @override
  State<ChallengeLandingScreen> createState() => _ChallengeLandingScreenState();
}

class _ChallengeLandingScreenState extends State<ChallengeLandingScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    context.read<DepartmentProvider>();
    context.read<JobProvider>();
    context.read<EmployeeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const ChallengeAppBar(
        landing: true,
      ),
      body: Stack(
        children: [
          Image.network(
            'https://statics.globant.com/production/public/2023-06/BG-footer-GL_home.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width > 800.0
                    ? 140.0
                    : width > 600
                        ? 30.0
                        : 10.0),
            child: width > 1250
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildLandingMessage(),
                      const HireEmployeeForm(),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 40.0),
                        buildLandingMessage(),
                        const SizedBox(height: 20.0),
                        const HireEmployeeForm(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

Widget buildLandingMessage() {
  return const Center(
    child: Text.rich(
      TextSpan(
          style: TextStyle(
            fontSize: 48.0,
          ),
          children: [
            TextSpan(
              text: 'Let us ',
              style: TextStyle(
                shadows: [Shadow(color: Colors.white, offset: Offset(0, -5.0))],
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFFa0f4a4),
                decorationThickness: 2.0,
              ),
            ),
            TextSpan(
              text: 'hire you',
              style: TextStyle(
                shadows: [Shadow(color: Colors.white, offset: Offset(0, -5.0))],
                color: Colors.transparent,
              ),
            ),
          ]),
    ),
  );
}
// globant green #c0d731
// underline #a0f4a4
// font #f8f4f4
// gradient #dcdc51 - #a0c050
// black #282424 #2d2f37
// white #ffffff
// grey #f0f0f0
// selected button #8cc53f
// button #c0d731
