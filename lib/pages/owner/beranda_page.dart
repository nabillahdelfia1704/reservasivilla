import 'package:flutter/material.dart';
import 'package:reservasi_villa/pages/auth/owner/login_page_owner.dart';
import 'package:reservasi_villa/pages/owner/edit_villa_page.dart';
import 'package:reservasi_villa/pages/owner/tambah_villa_page.dart';
import '../data/data_villa.dart';
import '../auth/owner/owner_auth.dart';
import 'profile_page.dart';
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

  void _loadVillas() {
    String currentOwnerId = OwnerAuth.currentOwner?['ownerId'] ?? "";
    setState(() {
      myVillas = villaList
          .where((v) => v['ownerId'] == currentOwnerId)
          .toList();
    });
  }

  void _showDeleteDialog(Map<String, dynamic> villa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Hapus Villa",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff003B73),
          ),
        ),
        content: Text(
          "Apakah kamu yakin ingin menghapus \"${villa['name']}\"?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                myVillas.removeWhere((v) => v['id'] == villa['id']);
                villaList.removeWhere((v) => v['id'] == villa['id']);
              });
              Navigator.pop(ctx);
            },
            child: const Text(
              "Ya, Hapus",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const DaftarPenyewaPage(),
      ProfilePage(
        onLogout: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const OwnerLoginPage()),
            (route) => false,
          );
        },
      ),
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
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff003B73),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahVillaPage()),
          ).then((value) {
            if (value != null && value is Map<String, dynamic>) {
              setState(() {
                myVillas.add(value);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

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
    String name = villa['name']?.toString() ?? 'Nama tidak tersedia';
    String lokasi = villa['lokasi']?.toString() ?? 'Lokasi tidak tersedia';
    String price = villa['price']?.toString() ?? '0';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: villa['image'] != null
                ? Image.asset(
                    villa['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 50)),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditVillaPage(villaData: villa),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          icon: const Icon(Icons.edit, size: 20),
                        ),
                        IconButton(
                          onPressed: () => _showDeleteDialog(villa),
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
                Text(lokasi, style: const TextStyle(color: Colors.grey)),
                Text(
                  "Rp $price / malam",
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
