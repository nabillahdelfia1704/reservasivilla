import 'package:flutter/material.dart';
import 'package:reservasi_villa/pages/auth/customer/registrasi_page.dart';
import 'submit_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variabel untuk show/hide password
  bool isHidden = true;

  // Controller untuk ambil teks dari field
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
      backgroundColor: Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Color(0xff003B73), size: 32),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          children: [
            SizedBox(height: 20),

            // Judul
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xff001B44),
              ),
            ),

            SizedBox(height: 1),

            Text(
              "Login dulu yuk, agar rencana healing kamu makin mantap!",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            SizedBox(height: 50),

            // ===== FIELD EMAIL =====
            Text(
              "Email",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 5),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "emailkamu@gmail.com",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // ===== FIELD PASSWORD =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Lupa Password?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff003B73),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),

            TextField(
              controller: passwordController,
              obscureText: isHidden,
              decoration: InputDecoration(
                hintText: "••••••••••",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                suffixIcon: IconButton(
                  onPressed: () {
                    // Tombol show/hide password
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  icon: Icon(
                    isHidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            SizedBox(height: 50),

            // ===== TOMBOL LOGIN =====
            // Kirim controller ke SubmitLogin
            SubmitLogin(
              emailController: emailController,
              passwordController: passwordController,
            ),

            // ===== TEKS "BELUM PUNYA AKUN?" =====
            const SizedBox(height: 20), // Jarak dari tombol login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Belum punya akun? ",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman registrasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Daftar sekarang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(
                        0xff003B73,
                      ), // Warna biru yang sama dengan tema Anda
                    ),
                  ),
                ),
              ],
            ),

            // ===== DIVIDER =====
            Row(
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "atau lanjut dengan",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),

            SizedBox(height: 30),

            // ===== TOMBOL SOSIAL =====
            Row(
              children: [
                // Google
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/img/google.jpeg', width: 30),
                        SizedBox(width: 8),
                        Text(
                          "Google",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 20),

                // Facebook
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.facebook, color: Colors.blue, size: 32),
                        SizedBox(width: 8),
                        Text(
                          "Facebook",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
