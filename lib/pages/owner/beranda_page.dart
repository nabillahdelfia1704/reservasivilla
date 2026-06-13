import 'package:flutter/material.dart';
import 'package:reservasi_villa/pages/owner/tambah_villa_page.dart';
import '../data/data_villa.dart';
import '../auth/owner_auth.dart';
import 'daftar_penyewa_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> myVillas = [];

  @override
  void initState() {
    super.initState();
    _loadVillas();
  }

  // Fungsi untuk memuat villa milik owner
  void _loadVillas() {
    String currentOwnerId = OwnerAuth.currentOwner?['ownerId'] ?? "";
    setState(() {
      myVillas = villaList
          .where((v) => v['ownerId'] == currentOwnerId)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const DaftarPenyewaPage(),
      const Center(child: Text("Halaman Profil")),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xff003B73),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Villa"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Penyewa"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.shield_moon, color: Color(0xff003B73)),
            SizedBox(width: 8),
            Text(
              "Manajemen Villa Owner",
              style: TextStyle(
                color: Color(0xff003B73),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildStatCard(
            "Total Properti",
            "${myVillas.length}",
            Icons.apartment,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            "Pendapatan (Bulan Ini)",
            "IDR 1.2M",
            Icons.account_balance_wallet,
          ),
          const SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myVillas.length,
            itemBuilder: (context, index) => _buildVillaItem(myVillas[index]),
          ),
          const SizedBox(height: 80), // Ruang untuk FAB
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff003B73),
        onPressed: () {
          // KUNCI PRESENTASI: .then() untuk menangkap data baru
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahVillaPage()),
          ).then((value) {
            // Jika ada data baru yang dikirim balik, tambahkan ke list
            if (value != null) {
              setState(() {
                myVillas.add(value); // Data langsung masuk ke list Beranda
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Widget StatCard dan VillaItem tetap sama ---
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(icon, size: 40, color: const Color(0xff003B73)),
        ],
      ),
    );
  }

  Widget _buildVillaItem(Map<String, dynamic> villa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: const Center(child: Icon(Icons.image, size: 50)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      villa['name'] ?? 'Villa Baru',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit, size: 20),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  villa['location'] ?? 'Lokasi belum diisi',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  "Rp ${villa['price'] ?? '0'} / malam",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
