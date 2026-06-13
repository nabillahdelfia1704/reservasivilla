import 'package:flutter/material.dart';
// Import file data dan service auth Anda
import '../data/data_villa.dart';
import '../auth/owner_auth.dart';

class DaftarPenyewaPage extends StatefulWidget {
  const DaftarPenyewaPage({super.key});

  @override
  State<DaftarPenyewaPage> createState() => _DaftarPenyewaPageState();
}

class _DaftarPenyewaPageState extends State<DaftarPenyewaPage> {
  String selectedVillaId = 'all';

  // Variabel untuk menampung data yang sudah difilter milik owner ini saja
  List<Map<String, dynamic>> myVillas = [];

  @override
  void initState() {
    super.initState();

    // 1. Ambil data owner yang sedang aktif
    final data = OwnerAuth.currentOwner;

    // 2. Ambil ID-nya (pastikan pakai 'ownerId' sesuai key di daftarOwner)
    String currentOwnerId = data != null ? (data['ownerId'] ?? "") : "";

    // 3. Langsung filter tanpa basa-basi
    myVillas = villaList.where((v) {
      return v['ownerId'] == currentOwnerId;
    }).toList();

    // Force update UI supaya list-nya muncul
    setState(() {});
  }

  String getRating() {
    if (selectedVillaId == 'all') {
      return "-";
    } else {
      final villa = myVillas.firstWhere(
        (v) => v['id'] == selectedVillaId,
        orElse: () => {'rating': 0.0},
      );
      return (villa['rating'] ?? 0.0).toString();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    // Filter booking berdasarkan villa yang sudah difilter di atas
    final filteredBookings = selectedVillaId == 'all'
        ? bookingList
              .where((b) => myVillas.any((v) => v['id'] == b['villaId']))
              .toList()
        : bookingList.where((b) => b['villaId'] == selectedVillaId).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text(
          "Daftar Penyewa",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff003B73),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips (Hanya menampilkan villa milik owner)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip('all', 'Semua Villa'),
                ...myVillas.map((v) => _buildFilterChip(v['id'], v['name'])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: _buildInfoCard("Rating Rata-rata", getRating()),
          ),

          // List Penyewa
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                final villa = myVillas.firstWhere(
                  (v) => v['id'] == booking['villaId'],
                  orElse: () => {'name': 'Villa Tidak Ditemukan'},
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            booking['customerName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(villa['name']),
                          trailing: const Chip(
                            label: Text(
                              "Lunas",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                              ),
                            ),
                            backgroundColor: Color(0xffE8F5E9),
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Check-in: ${formatTanggal(booking['startDate'])}",
                                ),
                                Text(
                                  "Check-out: ${formatTanggal(booking['endDate'])}",
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Detail"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String id, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedVillaId == id,
        onSelected: (selected) => setState(() => selectedVillaId = id),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
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
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff003B73),
            ),
          ),
        ],
      ),
    );
  }
}
