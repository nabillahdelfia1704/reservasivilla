import 'package:flutter/material.dart';
import 'package:reservasi_villa/pages/auth/customer/login_page.dart';
import 'auth_service.dart';

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
                content: const Text("Semua field wajib diisi!"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
            return;
          }

          // Validasi format email
          if (!email.contains('@') || !email.contains('.')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Format email tidak valid!"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
            return;
          }

          // Validasi password minimal 6 karakter
          if (password.length < 6) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Password minimal 6 karakter!"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
            return;
          }

          // Validasi konfirmasi password
          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "Password dan konfirmasi password tidak sama!",
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Registrasi berhasil! Silakan login."),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );

          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff003B73),
          elevation: 10,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),

        child: const Text(
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
