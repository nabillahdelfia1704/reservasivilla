import 'package:flutter/material.dart';
import 'submit_registrasi_owner.dart';

class RegisterOwnerPage extends StatefulWidget {
  const RegisterOwnerPage({super.key});

  @override
  State<RegisterOwnerPage> createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends State<RegisterOwnerPage> {
  bool isHidden = true;
  bool isHiddenConfirm = true;
  bool isChecked = false;

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff003B73),
            size: 32,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          children: [
            const SizedBox(height: 20),

            // Title
            const Text(
              "Owner Register",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xff001B44),
              ),
            ),

            const SizedBox(height: 1),

            const Text(
              "Lengkapi data untuk mengakses dashboard owner",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 50),

            // Nama Lengkap
            const Text(
              "Nama Lengkap",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                hintText: "Nama lengkap kamu",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Email
            const Text(
              "Email",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "emailkamu@gmail.com",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Password
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: isHidden,
              decoration: InputDecoration(
                hintText: "••••••••",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => isHidden = !isHidden),
                  icon: Icon(
                    isHidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Konfirmasi Password
            const Text(
              "Konfirmasi Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: confirmPasswordController,
              obscureText: isHiddenConfirm,
              decoration: InputDecoration(
                hintText: "••••••••",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => isHiddenConfirm = !isHiddenConfirm),
                  icon: Icon(
                    isHiddenConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Checkbox syarat & ketentuan
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: const Color(0xff003B73),
                  onChanged: (v) => setState(() => isChecked = v!),
                ),
                const Expanded(
                  child: Text(
                    "Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi owner Villaku.",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Button
            SubmitRegistrasiOwner(
              namaController: namaController,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              isAccepted: isChecked,
            ),

            const SizedBox(height: 30),

            // Sudah punya akun
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sudah punya akun? ",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Masuk di sini",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff003B73),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
