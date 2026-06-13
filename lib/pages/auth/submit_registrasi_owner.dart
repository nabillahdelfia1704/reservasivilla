import 'package:flutter/material.dart';

class SubmitRegistrasiOwner extends StatelessWidget {
  final TextEditingController nama, id, email, pass;
  final bool isAccepted;

  const SubmitRegistrasiOwner({
    super.key,
    required this.nama,
    required this.id,
    required this.email,
    required this.pass,
    required this.isAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff003B73),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (!isAccepted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Harap setujui syarat & ketentuan")),
            );
            return;
          }
          // Tambahkan logika simpan data ke daftarOwner di sini
          print("Registrasi Berhasil untuk: ${nama.text}");
          Navigator.pop(context);
        },
        child: const Text(
          "Daftar Sekarang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
