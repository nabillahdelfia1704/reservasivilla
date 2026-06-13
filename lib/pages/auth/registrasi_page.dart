import 'package:flutter/material.dart';
import 'submit_registrasi.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isHidden = true;
  bool isHiddenConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leadingWidth: 80,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back, color: Color(0xff003B73), size: 32),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),

          children: [
            SizedBox(height: 20),

            // Title
            Text(
              "Create Account",

              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xff001B44),
              ),
            ),

            SizedBox(height: 1),

            Text(
              "Bikin akun dan mulai cari villa impianmu",

              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            SizedBox(height: 50),

            // Full Name
            Text(
              "Nama Lengkap",

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),

            SizedBox(height: 5),

            TextField(
              decoration: InputDecoration(
                hintText: "Nama lengkap kamu",

                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),

                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Email
            Text(
              "Email",

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),

            SizedBox(height: 5),

            TextField(
              decoration: InputDecoration(
                hintText: "emailkamu@gmail.com",

                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),

                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Password
            Text(
              "Password",

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),

            SizedBox(height: 5),

            TextField(
              obscureText: isHidden,

              decoration: InputDecoration(
                hintText: "••••••••",

                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },

                  icon: Icon(
                    isHidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,

                    color: Colors.grey,
                    size: 28,
                  ),
                ),

                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff003B73), width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Confirm Password
            Text(
              "konfirmasiss Password",

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),

            SizedBox(height: 5),

            TextField(
              obscureText: isHiddenConfirm,

              decoration: InputDecoration(
                hintText: "••••••••",

                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHiddenConfirm = !isHiddenConfirm;
                    });
                  },

                  icon: Icon(
                    isHiddenConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,

                    color: Colors.grey,
                    size: 28,
                  ),
                ),

                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
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

            // Button
            SubmitRegistrasi(),

            SizedBox(height: 40),

            // Divider
            Row(
              children: [
                Expanded(child: Divider(thickness: 1)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),

                  child: Text(
                    "OR SIGN UP WITH",

                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Expanded(child: Divider(thickness: 1)),
              ],
            ),

            SizedBox(height: 40),

            // Social Button
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
                        Image.asset('assets/img/google.png', width: 30),

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

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
