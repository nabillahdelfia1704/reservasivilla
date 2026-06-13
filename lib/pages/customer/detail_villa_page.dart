import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'konfirmasi_page.dart';
import '../auth/login_page.dart';
import '../auth/customer_auth.dart';

class DetailVillaPage extends StatelessWidget {
  final Map villa;
  final String tanggal;
  final int jumlahTamu;

  const DetailVillaPage({
    super.key,
    required this.villa,
    required this.tanggal,
    required this.jumlahTamu,
  });

  int getJumlahMalam() {
    try {
      final parts = tanggal.split(" - ");
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
    if (villa["pool"] == true)
      result.add({"icon": Icons.pool, "label": "Kolam Renang"});
    if (villa["wifi"] == true)
      result.add({"icon": Icons.wifi, "label": "WiFi"});
    if (villa["parkir"] == true)
      result.add({"icon": Icons.local_parking, "label": "Parkir Gratis"});
    if (villa["ac"] == true) result.add({"icon": Icons.ac_unit, "label": "AC"});
    if (villa["dapur"] == true)
      result.add({"icon": Icons.restaurant, "label": "Dapur"});
    if (villa["bakMandi"] == true)
      result.add({"icon": Icons.bathtub_outlined, "label": "Bak Mandi"});
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final int jumlahMalam = getJumlahMalam();
    final fasilitasList = _buildFasilitasList();
    final bool isAsset = villa["image"].toString().startsWith("assets/");

    // Harga untuk ditampilkan di bottom bar
    final int hargaPerMalam = int.parse(
      villa["price"].toString().replaceAll(".", ""),
    );
    final int subtotal = hargaPerMalam * jumlahMalam;
    const int serviceFee = 240000;
    final int total = subtotal + serviceFee;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      // ── BOTTOM BAR: harga + tombol ──
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Harga singkat
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp ${villa["price"]}",
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
            // Tombol konfirmasi
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
                              villa: villa,
                              tanggal: tanggal,
                              jumlahTamu: jumlahTamu,
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
                        villa: villa,
                        tanggal: tanggal,
                        jumlahTamu: jumlahTamu,
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

            // ── FOTO VILLA ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: isAsset
                        ? Image.asset(
                            villa["image"],
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            villa["image"],
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
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xff003B73),
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        villa["rating"].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "• 128 Reviews",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama
                  Text(
                    villa["name"],
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    villa["location"],
                    style: const TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                  const SizedBox(height: 25),

                  // Feature cards
                  Row(
                    children: [
                      _featureCard(
                        Icons.bed_outlined,
                        "${villa["bedroom"] ?? "-"} Kamar",
                      ),
                      const SizedBox(width: 10),
                      _featureCard(
                        Icons.bathtub_outlined,
                        "${villa["bathroom"] ?? "-"} Kamar mandi",
                      ),
                      const SizedBox(width: 10),
                      _featureCard(
                        Icons.people_outline,
                        "${villa["guests"] ?? "-"} Tamu",
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Deskripsi
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    villa["description"] ??
                        "Villa dengan fasilitas lengkap dan pemandangan indah.",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Lokasi
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
                          villa["alamat"] ?? villa["location"],
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
                                  villa["location_rating"]?.toString() ?? "8.3",
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
                              villa["address"] ??
                                  villa["location"] ??
                                  "Alamat lengkap belum tersedia.",
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

                  // Fasilitas
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

                  const SizedBox(
                    height: 100,
                  ), // ruang agar konten tidak tertutup bottom bar
                ],
              ),
            ),
          ],
        ),
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
