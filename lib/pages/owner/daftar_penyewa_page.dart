import 'package:flutter/material.dart';
import '../data/data_villa.dart';
import '../auth/owner/owner_auth.dart';
import 'detail_penyewa_page.dart';

class DaftarPenyewaPage extends StatefulWidget {
  const DaftarPenyewaPage({super.key});

  @override
  State<DaftarPenyewaPage> createState() => _DaftarPenyewaPageState();
}

class _DaftarPenyewaPageState extends State<DaftarPenyewaPage> {
  String selectedVillaId = 'all';
  List<Map<String, dynamic>> myVillas = [];

  @override
  void initState() {
    super.initState();
    final data = OwnerAuth.currentOwner;
    String currentOwnerId = data != null ? (data['ownerId'] ?? "") : "";
    myVillas = villaList.where((v) => v['ownerId'] == currentOwnerId).toList();
    setState(() {});
  }

  String getRating() {
    if (selectedVillaId == 'all') return "-";
    final villa = myVillas.firstWhere(
      (v) => v['id'] == selectedVillaId,
      orElse: () => {'rating': 0.0},
    );
    return (villa['rating'] ?? 0.0).toString();
  }

  // ✅ TAMBAHAN: Ambil ulasan sesuai filter villa yang aktif
  List<Map<String, dynamic>> getUlasanFiltered() {
    if (selectedVillaId == 'all') {
      return ulasanList
          .where((u) => myVillas.any((v) => v['id'] == u['villaId']))
          .toList();
    }
    return ulasanList.where((u) => u['villaId'] == selectedVillaId).toList();
  }

  // ✅ TAMBAHAN: Tampilkan bottom sheet daftar ulasan
  void _showUlasanBottomSheet() {
    final ulasan = getUlasanFiltered();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ulasan Tamu",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff003B73),
                        ),
                      ),
                      Text(
                        "${ulasan.length} ulasan",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 20),
                Expanded(
                  child: ulasan.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada ulasan",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: ulasan.length,
                          separatorBuilder: (_, _) => const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final u = ulasan[index];
                            // Cari nama villa untuk tampilan "Semua Villa"
                            final villaName =
                                villaList.firstWhere(
                                      (v) => v['id'] == u['villaId'],
                                      orElse: () => {'name': ''},
                                    )['name']
                                    as String;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Avatar inisial
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: const Color(0xffE8F0FB),
                                      child: Text(
                                        (u['nama'] as String)
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff003B73),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            u['nama'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Tampilkan nama villa kalau mode "Semua"
                                          if (selectedVillaId == 'all')
                                            Text(
                                              villaName,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Bintang
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          Icons.star,
                                          size: 14,
                                          color: i < (u['bintang'] as int)
                                              ? Colors.amber
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(u['komentar']),
                                const SizedBox(height: 4),
                                Text(
                                  u['tanggal'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
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
            // ✅ UBAH: Bungkus InfoCard dengan GestureDetector
            child: GestureDetector(
              onTap: _showUlasanBottomSheet,
              child: _buildInfoCard("Rating Rata-rata", getRating()),
            ),
          ),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailPenyewaPage(booking: booking),
                                  ),
                                );
                              },
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

  // ✅ UBAH: Tambahkan hint "Tap untuk lihat ulasan" di bawah value
  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
              const Text(
                "Tap untuk lihat ulasan",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
