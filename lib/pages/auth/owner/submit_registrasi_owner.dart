import 'package:flutter/material.dart';
import 'package:reservasi_villa/pages/auth/owner/login_page_owner.dart';
import 'owner_auth.dart';

class SubmitRegistrasiOwner extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isAccepted;

  const SubmitRegistrasiOwner({
    super.key,
    required this.namaController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isAccepted,
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
          final password = passwordController.text.trim();
          final confirmPassword = confirmPasswordController.text.trim();

          // Validasi syarat & ketentuan
          if (!isAccepted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Harap setujui syarat & ketentuan!"),
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

          // Validasi field kosong
          if (nama.isEmpty ||
              email.isEmpty ||
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

          // Simpan ke OwnerAuth
          OwnerAuth.login({
            'nama_lengkap': nama,
            'email': email,
            'pendapatan': '0',
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registrasi berhasil! Silakan login."),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(16),
            ),
          );

          if (!context.mounted) return;
          // Langsung ke BerandaPage owner
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const OwnerLoginPage()),
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
          "Daftar Sekarang",
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
