import 'package:employees_site/ui/screens/crud_screen.dart';
import 'package:flutter/material.dart';

class ChallengeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool landing;
  const ChallengeAppBar({this.landing = false, super.key});

  @override
  State<ChallengeAppBar> createState() => _ChallengeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChallengeAppBarState extends State<ChallengeAppBar> {
  bool _buttonHovered = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Globant',
        style: TextStyle(fontSize: 28.0),
      ), // Coolvetica font
      centerTitle: false,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CrudScreen()));
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
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
