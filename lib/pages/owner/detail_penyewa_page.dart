import 'package:flutter/material.dart';
import '../data/data_villa.dart';

class DetailPenyewaPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const DetailPenyewaPage({super.key, required this.booking});

  String formatTanggal(DateTime date) {
    final List<String> bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return "${date.day} ${bulan[date.month]} ${date.year}";
  }

  int hitungDurasi(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  String formatRupiah(num harga) {
    final str = harga.toInt().toString();
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
    // Ambil data villa berdasarkan villaId dari booking
    final villa = villaList.firstWhere(
      (v) => v['id'] == booking['villaId'],
      orElse: () => {},
    );

    final DateTime startDate = booking['startDate'];
    final DateTime endDate = booking['endDate'];
    final int durasi = hitungDurasi(startDate, endDate);
    final num hargaPerMalam =
        num.tryParse(villa['price']?.toString().replaceAll('.', '') ?? '') ??
        num.tryParse(villa['harga']?.toString().replaceAll('.', '') ?? '') ??
        0;
    final num totalHarga = hargaPerMalam * durasi;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text(
          "Detail Penyewa",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff003B73),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff003B73)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card Info Penyewa ──
            _sectionCard(
              title: "Informasi Penyewa",
              child: Column(
                children: [
                  _infoRow(
                    Icons.person,
                    "Nama",
                    booking['customerName'] ?? '-',
                  ),
                  _infoRow(
                    Icons.confirmation_number,
                    "Booking ID",
                    booking['bookingId'] ?? '-',
                  ),
                  _infoRow(
                    Icons.person,
                    "Nama",
                    booking['customerName'] ?? '-',
                  ),
                  _infoRow(Icons.email, "Email", booking['email'] ?? '-'),
                  _infoRow(Icons.phone, "No. HP", booking['no_hp'] ?? '-'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Card Info Villa ──
            _sectionCard(
              title: "Informasi Villa",
              child: Column(
                children: [
                  _infoRow(Icons.villa, "Nama Villa", villa['name'] ?? '-'),
                  _infoRow(
                    Icons.location_on,
                    "Lokasi",
                    villa['location'] ?? villa['lokasi'] ?? '-',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Card Tanggal & Durasi ──
            _sectionCard(
              title: "Detail Menginap",
              child: Column(
                children: [
                  _infoRow(Icons.login, "Check-in", formatTanggal(startDate)),
                  _infoRow(Icons.logout, "Check-out", formatTanggal(endDate)),
                  _infoRow(Icons.nights_stay, "Durasi", "$durasi malam"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Card Harga ──
            _sectionCard(
              title: "Ringkasan Pembayaran",
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F6FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _payRow(
                          '${formatRupiah(hargaPerMalam)} × $durasi malam',
                          formatRupiah(totalHarga),
                        ),
                        const SizedBox(height: 8),
                        _payRow('Pajak', formatRupiah(10000)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xff001B44),
                              ),
                            ),
                            Text(
                              formatRupiah(totalHarga + 10000),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xff003B73),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "✓ Lunas",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xff003B73)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _payRow(String label, String value, {bool isDiskon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: isDiskon ? Colors.red : const Color(0xff001B44),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
