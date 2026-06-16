import 'package:flutter/material.dart';

class SubmitRegistrasiOwner extends StatelessWidget {
  final TextEditingController nama, email, pass;
  final bool isAccepted;

  const SubmitRegistrasiOwner({
    super.key,
    required this.nama,
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
