import 'package:flutter/material.dart';
import 'submit_login_owner.dart';
import 'register_page_owner.dart';

class OwnerLoginPage extends StatefulWidget {
  const OwnerLoginPage({super.key});

  @override
  State<OwnerLoginPage> createState() => _OwnerLoginPageState();
}

class _OwnerLoginPageState extends State<OwnerLoginPage> {
  bool isHidden = true;
  bool isRememberMe = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Logo & Judul
              const Icon(Icons.shield_moon, size: 60, color: Color(0xff003B73)),
              const SizedBox(height: 16),
              const Text(
                "LuxeStay",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff001B44),
                ),
              ),
              const Text(
                "Owner Portal",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Card Box
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Owner ID / Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Masukan ID atau Email",
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Kata Sandi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: isHidden,
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        suffixIcon: IconButton(
                          icon: Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => isHidden = !isHidden),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isRememberMe,
                              onChanged: (v) =>
                                  setState(() => isRememberMe = v!),
                            ),
                            const Text("Ingat Saya"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Lupa Kata Sandi?"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tombol Submit (Langsung diisi controller dari page ini)
                    SubmitLogin(
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text("Belum memiliki akses owner?"),
              TextButton(
                onPressed: () {
                  // 2. Navigasi ke halaman Register
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterOwnerPage(),
                    ),
                  );
                },
                child: const Text(
                  "Daftar Akun Baru",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                "© 2024 LuxeStay Property Management. All Rights Reserved.",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Syarat & Ketentuan"),
                  SizedBox(width: 10),
                  Text("Kebijakan Privasi"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
