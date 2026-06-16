import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../../customer/beranda_page.dart';

class SubmitRegistrasi extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController emailController;
  final TextEditingController hpController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SubmitRegistrasi({
    super.key,
    required this.namaController,
    required this.emailController,
    required this.hpController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: ElevatedButton(
        onPressed: () {
          final nama = namaController.text.trim();
          final email = emailController.text.trim();
          final hp = hpController.text.trim();
          final password = passwordController.text.trim();
          final confirmPassword = confirmPasswordController.text.trim();

          // Validasi field kosong
          if (nama.isEmpty ||
              email.isEmpty ||
              hp.isEmpty ||
              password.isEmpty ||
              confirmPassword.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Semua field wajib diisi!"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(16),
              ),
            );
            return;
          }

          // Validasi format email
          if (!email.contains('@') || !email.contains('.')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Format email tidak valid!"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(16),
              ),
            );
            return;
          }

          // Validasi password minimal 6 karakter
          if (password.length < 6) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Password minimal 6 karakter!"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(16),
              ),
            );
            return;
          }

          // Validasi konfirmasi password
          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Password dan konfirmasi password tidak sama!"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(16),
              ),
            );
            return;
          }

          // Simpan ke AuthService
          AuthService.login({
            'nama_lengkap': nama,
            'email': email,
            'no_hp': hp,
          });

          // Langsung ke BerandaPage
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const BerandaPage()),
            (route) => false,
          );
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
