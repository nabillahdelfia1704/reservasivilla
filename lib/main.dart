import 'package:flutter/material.dart';
import 'package:reservasi_villa/pages/auth/customer/login_page.dart';
import 'package:reservasi_villa/pages/auth/owner/login_page_owner.dart';
//import 'package:reservasi_villa/pages/auth/login_page.dart';
import 'package:reservasi_villa/pages/customer/beranda_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Villaku',
      home: BerandaPage(),
    );
  }
}
