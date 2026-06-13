import 'package:flutter/material.dart';
import 'pages/auth/login_page_owner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reservasi Villaku',
      home: OwnerLoginPage(),
    );
  }
}
