import 'package:flutter/material.dart';
import 'beranda_page.dart';

class SuksesPage extends StatelessWidget {
  final Map villa;
  final String tanggal;
  final int total;
  final String metodeBayar;

  const SuksesPage({
    super.key,
    required this.villa,
    required this.tanggal,
    required this.total,
    required this.metodeBayar,
  });

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    // Buat kode booking dummy
    final String kodePesanan =
        'VLK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // ── Animasi centang ──
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xff003B73),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Pemesanan Berhasil!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih! Pesanan kamu sudah dikonfirmasi.',
                style: TextStyle(color: Colors.black54, fontSize: 15),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ── Detail pesanan ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _row('Kode Pesanan', kodePesanan, bold: true),
                    const Divider(height: 20),
                    _row('Villa', villa['name']),
                    const SizedBox(height: 8),
                    _row('Lokasi', villa['location']),
                    const SizedBox(height: 8),
                    _row('Check-in', tanggal.split(' - ')[0]),
                    const SizedBox(height: 8),
                    _row('Check-out', tanggal.split(' - ')[1]),
                    const Divider(height: 20),
                    _row('Metode Bayar', metodeBayar),
                    const SizedBox(height: 8),
                    _row('Total Dibayar', _formatRupiah(total), bold: true),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Info ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffE8F4FD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Color(0xff003B73)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Detail pesanan dan konfirmasi akan dikirim ke email kamu.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff003B73),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Tombol Kembali ke Beranda ──
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const BerandaPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff003B73),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: bold ? const Color(0xff001B44) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
