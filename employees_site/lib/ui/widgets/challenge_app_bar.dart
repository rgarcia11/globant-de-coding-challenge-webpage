import 'package:employees_site/ui/screens/challenge_landing_screen.dart';
import 'package:employees_site/ui/screens/crud_screen.dart';
import 'package:flutter/material.dart';

class ChallengeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool landing;
  final List<Widget>? actions;
  const ChallengeAppBar({this.landing = false, this.actions, super.key});

  @override
  State<ChallengeAppBar> createState() => _ChallengeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChallengeAppBarState extends State<ChallengeAppBar> {
  bool _buttonHovered = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = 10.0;
    if (width > 1250) {
      padding = 140.0;
    } else if (width > 670) {
      padding = 100;
    } else {
      padding = 10.0;
    }
    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      title: Transform.translate(
        offset: Offset(padding - 15.0, 0.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ChallengeLandingScreen(),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                'Globant',
                style: TextStyle(
                    fontSize: width < 800 ? 22.0 : 28.0,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  width: width < 800 ? 20.0 : 27.0,
                  height: width < 800 ? 20.0 : 27.0,
                  child: Image.asset(
                    'assets/Logo.png',
                    fit: BoxFit.contain,
                  )),
            ],
          ),
        ),
      ),
      actions: widget.landing
          ? [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CrudScreen()));
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
                  'SEE THE CHALLENGE',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: padding),
            ]
          : widget.actions != null
              ? [
                  ...widget.actions!,
                  SizedBox(width: widget.landing ? 140.0 - 15.0 : padding),
                ]
              : null,
    );
  }
}
