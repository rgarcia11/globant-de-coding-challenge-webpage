import 'package:employees_site/ui/widgets/challenge_app_bar.dart';
import 'package:employees_site/ui/widgets/new_employee_form.dart';
import 'package:flutter/material.dart';

class ChallengeLandingScreen extends StatelessWidget {
  const ChallengeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Row(
            // direction: isScreenWide ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text.rich(
                  TextSpan(
                      style: TextStyle(
                        fontSize: 48.0,
                      ),
                      children: [
                        TextSpan(
                          text: 'Let us ',
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.white, offset: Offset(0, -5.0))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFa0f4a4),
                            decorationThickness: 2.0,
                          ),
                        ),
                        TextSpan(
                          text: 'hire you',
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.white, offset: Offset(0, -5.0))
                            ],
                            color: Colors.transparent,
                          ),
                        ),
                      ]),
                ),
              ), // Araboto font
              NewEmployeeForm(landing: true),
            ],
          ),
        ],
      ),
    );
  }
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