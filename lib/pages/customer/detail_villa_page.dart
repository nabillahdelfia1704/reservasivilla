import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'konfirmasi_page.dart';
import 'ulasan_page.dart';
import '../auth/customer/login_page.dart';
import '../auth/customer/auth_service.dart';
import '../data/data_villa.dart';

class DetailVillaPage extends StatefulWidget {
  final Map villa;
  final String tanggal;
  final int jumlahTamu;

  const DetailVillaPage({
    super.key,
    required this.villa,
    required this.tanggal,
    required this.jumlahTamu,
  });

  @override
  State<DetailVillaPage> createState() => _DetailVillaPageState();
}

class _DetailVillaPageState extends State<DetailVillaPage> {
  String formatRupiah(int angka) {
    final str = angka.toString();
    final buffer = StringBuffer();
    int counter = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (counter > 0 && counter % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      counter++;
    }
    return buffer.toString().split('').reversed.join('');
  }

  int getJumlahMalam() {
    try {
      final parts = widget.tanggal.split(" - ");
      final checkInParts = parts[0].split("/");
      final checkOutParts = parts[1].split("/");
      final checkIn = DateTime(
        int.parse(checkInParts[2]),
        int.parse(checkInParts[1]),
        int.parse(checkInParts[0]),
      );
      final checkOut = DateTime(
        int.parse(checkOutParts[2]),
        int.parse(checkOutParts[1]),
        int.parse(checkOutParts[0]),
      );
      return checkOut.difference(checkIn).inDays;
    } catch (e) {
      return 1;
    }
  }

  void _bukaPeta(BuildContext context, String alamat) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(alamat)}";
    final Uri url = Uri.parse(googleMapsUrl);
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak dapat membuka Google Maps")),
        );
      }
    }
  }

  List<Map<String, dynamic>> _buildFasilitasList() {
    final List<Map<String, dynamic>> result = [];
    if (widget.villa["pool"] == true) {
      result.add({"icon": Icons.pool, "label": "Kolam Renang"});
    }
    if (widget.villa["wifi"] == true) {
      result.add({"icon": Icons.wifi, "label": "WiFi"});
    }
    if (widget.villa["parkir"] == true) {
      result.add({"icon": Icons.local_parking, "label": "Parkir Gratis"});
    }
    if (widget.villa["ac"] == true) {
      result.add({"icon": Icons.ac_unit, "label": "AC"});
    }
    if (widget.villa["dapur"] == true) {
      result.add({"icon": Icons.restaurant, "label": "Dapur"});
    }
    if (widget.villa["bakMandi"] == true) {
      result.add({"icon": Icons.bathtub_outlined, "label": "Bak Mandi"});
    }
    return result;
  }

  Widget _buildUlasanCard(Map u) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF5F6FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                u['nama'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                u['tanggal'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < (u['bintang'] ?? 0) ? Icons.star : Icons.star_border,
                size: 14,
                color: const Color(0xff003B73),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            u['komentar'],
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  static Widget _featureCard(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xffEEF2F7),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int jumlahMalam = getJumlahMalam();
    final fasilitasList = _buildFasilitasList();

    final String image = widget.villa["image"]?.toString() ?? '';
    final String name =
        widget.villa["name"]?.toString() ?? 'Nama tidak tersedia';
    final String lokasi = widget.villa["lokasi"]?.toString() ?? '';
    final String rating = widget.villa["rating"]?.toString() ?? '0.0';
    final String priceRaw = widget.villa["price"]?.toString() ?? '0';
    final bool isAsset = image.startsWith("assets/");

    final int hargaPerMalam = int.tryParse(priceRaw.replaceAll(".", "")) ?? 0;
    final int subtotal = hargaPerMalam * jumlahMalam;
    const int serviceFee = 10000;
    final int total = subtotal + serviceFee;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp ${formatRupiah(hargaPerMalam)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff001B44),
                    ),
                  ),
                  Text(
                    "/ malam · $jumlahMalam malam",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (!AuthService.isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ).then((_) {
                      if (AuthService.isLoggedIn && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KonfirmasiPage(
                              villa: widget.villa,
                              tanggal: widget.tanggal,
                              jumlahTamu: widget.jumlahTamu,
                              jumlahMalam: jumlahMalam,
                              subtotal: subtotal,
                              serviceFee: serviceFee,
                              total: total,
                            ),
                          ),
                        );
                      }
                    });
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KonfirmasiPage(
                        villa: widget.villa,
                        tanggal: widget.tanggal,
                        jumlahTamu: widget.jumlahTamu,
                        jumlahMalam: jumlahMalam,
                        subtotal: subtotal,
                        serviceFee: serviceFee,
                        total: total,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff003B73),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Konfirmasi Pesanan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: image.isEmpty
                        ? Container(
                            height: 260,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            ),
                          )
                        : isAsset
                        ? Image.asset(
                            image,
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            image,
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 15,
                    child: Row(
                      children: const [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.share, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xff003B73),
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        rating,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lokasi,
                    style: const TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      _featureCard(
                        Icons.bed_outlined,
                        "${widget.villa["bedroom"] ?? "-"} Kamar",
                      ),
                      const SizedBox(width: 10),
                      _featureCard(
                        Icons.bathtub_outlined,
                        "${widget.villa["bathroom"] ?? "-"} Kamar mandi",
                      ),
                      const SizedBox(width: 10),
                      _featureCard(
                        Icons.people_outline,
                        "${widget.villa["guests"] ?? "-"} Tamu",
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.villa["description"]?.toString() ??
                        "Villa dengan fasilitas lengkap dan pemandangan indah.",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Lokasi",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _bukaPeta(
                          context,
                          widget.villa["alamat"]?.toString() ?? lokasi,
                        ),
                        child: const Text(
                          "Buka peta",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff003B73),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.location_on,
                                color: Color(0xff003B73),
                                size: 30,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.open_in_full,
                                  size: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.villa["location_rating"]?.toString() ??
                                      "8.3",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2D3142),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Luar biasa",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2D3142),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Nilai lokasi",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.villa["address"]?.toString() ?? lokasi,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Fasilitas",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  fasilitasList.isEmpty
                      ? const Text(
                          "Tidak ada fasilitas tercatat.",
                          style: TextStyle(color: Colors.grey),
                        )
                      : Wrap(
                          spacing: 30,
                          runSpacing: 18,
                          children: fasilitasList
                              .map((f) => _Amenity(f["icon"], f["label"]))
                              .toList(),
                        ),
                  const SizedBox(height: 30),

                  // ── ULASAN ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ulasan",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (!AuthService.isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UlasanPage(
                                villaId: widget.villa["id"]?.toString() ?? '',
                                villaName: name,
                                customerName:
                                    AuthService.currentUser?['nama_lengkap'] ??
                                    'Tamu',
                              ),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        child: const Text(
                          'Tulis Ulasan',
                          style: TextStyle(
                            color: Color(0xff003B73),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...ulasanList
                      .where((u) => u['villaId'] == widget.villa['id'])
                      .map((u) => _buildUlasanCard(u)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Amenity extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Amenity(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff003B73)),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
