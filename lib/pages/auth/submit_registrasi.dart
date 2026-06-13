import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class SubmitRegistrasi extends StatelessWidget {
  const SubmitRegistrasi({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72,

      child: ElevatedButton(
        onPressed: () {
          AuthService.login({
            'nama': 'User Baru',
            'email': 'userbaru@email.com',
          });

          Navigator.pop(context); // tutup RegisterPage
          Navigator.pop(context); // tutup LoginPage
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff003B73),

          elevation: 10,

          shadowColor: Colors.black26,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),

        child: Text(
          "Sign Up",

          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
