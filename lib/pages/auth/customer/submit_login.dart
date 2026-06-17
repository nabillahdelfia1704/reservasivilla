import 'package:flutter/material.dart';
import '../../data/data_user.dart';
import 'auth_service.dart';
import '../../customer/beranda_page.dart';

class SubmitLogin extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SubmitLogin({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SubmitLogin> createState() => _SubmitLoginState();
}

class _SubmitLoginState extends State<SubmitLogin> {
  bool isLoading = false;

  Future<void> prosesLogin() async {
    String email = widget.emailController.text.trim();
    String password = widget.passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      tampilPesan("Email dan password wajib diisi!");
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      tampilPesan("Format email tidak valid!");
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Map<String, String>? customerSesuai;
    for (var cust in daftarCustomer) {
      if (cust['email'] == email && cust['password'] == password) {
        customerSesuai = cust;
        break;
      }
    }

    setState(() => isLoading = false);

    if (customerSesuai != null) {
      final userData = Map<String, dynamic>.from(customerSesuai);
      AuthService.login(userData);

      final String nama = userData['nama_lengkap'] ?? 'Pengguna';
      tampilPesan("Selamat datang, $nama!");

      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BerandaPage()),
        (route) => false,
      );
    } else {
      tampilPesan("Email atau password salah, atau akun Anda tidak dikenali!");
    }
  }

  void tampilPesan(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : prosesLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff003B73),
          elevation: 10,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                "Sign In",
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
