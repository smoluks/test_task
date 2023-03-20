import 'package:flutter/material.dart';

import 'pages/start_page.dart';

void main(List<String> args) async {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: StartPage());
  }
}
