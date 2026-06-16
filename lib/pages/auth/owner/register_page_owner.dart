import 'package:flutter/material.dart';
import 'submit_registrasi_owner.dart';

class RegisterOwnerPage extends StatefulWidget {
  const RegisterOwnerPage({super.key});

  @override
  State<RegisterOwnerPage> createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends State<RegisterOwnerPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Admin Register",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff001B44),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lengkapi data Anda untuk mengakses dashboard admin.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      "Nama Lengkap",
                      "Masukkan nama lengkap",
                      namaController,
                    ),

                    _buildField("Email", "admin@luxestay.com", emailController),

                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: isHidden,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => isHidden = !isHidden),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (v) => setState(() => isChecked = v!),
                        ),
                        const Expanded(
                          child: Text(
                            "Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi admin LuxeStay.",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SubmitRegistrasiOwner(
                      nama: namaController,
                      email: emailController,
                      pass: passwordController,
                      isAccepted: isChecked,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah memiliki akun? "),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Masuk di sini",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
