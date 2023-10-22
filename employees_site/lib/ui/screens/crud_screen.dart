import 'package:employees_site/ui/widgets/challenge_app_bar.dart';
import 'package:flutter/material.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ChallengeAppBar(),
    );
  }
}
