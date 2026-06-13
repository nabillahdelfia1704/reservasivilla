import 'package:flutter/material.dart';
import '../auth/owner_auth.dart';
import '../data/data_user.dart';
import '../owner/beranda_page.dart';

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
      tampilPesan("Email dan Password harus diisi");
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulasi proses loading

    // --- LOGIKA MENCARI DATA OWNER ---
    Map<String, String>? ownerSesuai;

    for (var owner in daftarOwner) {
      if (owner['email'] == email && owner['password'] == password) {
        ownerSesuai = owner;
        break; // Berhenti mencari jika sudah ketemu
      }
    }

    setState(() => isLoading = false);

    // --- PENGECEKAN HASIL ---
    if (ownerSesuai != null) {
      // 1. TAMBAHKAN BARIS INI: Ini adalah cara "mendaftarkan" user yang login ke sistem
      OwnerAuth.login(ownerSesuai);

      // 2. Tampilkan pesan berhasil
      tampilPesan("Selamat datang, ${ownerSesuai['nama_lengkap']}!");

      // 3. Pindah ke halaman Beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BerandaPage()),
      );
    } else {
      // Login Gagal
      tampilPesan("Email atau Password salah!");
    }
  }

  // Helper untuk menampilkan pesan
  void tampilPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (kode build Anda tetap sama)
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff003B73),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLoading ? null : prosesLogin,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                ],
              ),
      ),
    );
  }
}
