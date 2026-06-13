import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data dummy riwayat pemesanan
  final List<Map<String, dynamic>> semuaPesanan = [
    {
      "id": "VB-202504-001",
      "villa": {
        "id": "v2",
        "name": "Villa Sunset",
        "city": "Bali",
        "location": "Bali, Indonesia",
        "rating": "4.95",
        "price": "920000",
        "guests": 4,
        "bedroom": 2,
        "bathroom": 2,
        "image": "assets/img/promo1.jpeg",
      },
      "checkIn": "12 Apr 2025",
      "checkOut": "15 Apr 2025",
      "jumlahMalam": 3,
      "jumlahTamu": 2,
      "total": 2900000,
      "status": "Selesai",
    },
    {
      "id": "VB-202505-002",
      "villa": {
        "id": "v2",
        "name": "Villa Sunset",
        "city": "Bali",
        "location": "Bali, Indonesia",
        "rating": "4.95",
        "price": "920000",
        "guests": 4,
        "bedroom": 2,
        "bathroom": 2,
        "image": "assets/img/promo1.jpeg",
      },
      "checkIn": "20 Mei 2025",
      "checkOut": "22 Mei 2025",
      "jumlahMalam": 2,
      "jumlahTamu": 4,
      "total": 1932000,
      "status": "Aktif",
    },
    {
      "id": "VB-202506-003",
      "villa": {
        "id": "v2",
        "name": "Villa Sunset",
        "city": "Bali",
        "location": "Bali, Indonesia",
        "rating": "4.95",
        "price": "920000",
        "guests": 4,
        "bedroom": 2,
        "bathroom": 2,
        "image": "assets/img/promo1.jpeg",
      },
      "checkIn": "10 Jun 2025",
      "checkOut": "13 Jun 2025",
      "jumlahMalam": 3,
      "jumlahTamu": 2,
      "total": 2900000,
      "status": "Dibatalkan",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get pesananAktif =>
      semuaPesanan.where((p) => p['status'] == 'Aktif').toList();

  List<Map<String, dynamic>> get pesananSelesai =>
      semuaPesanan.where((p) => p['status'] == 'Selesai').toList();

  List<Map<String, dynamic>> get pesananDibatalkan =>
      semuaPesanan.where((p) => p['status'] == 'Dibatalkan').toList();

  Color _statusColor(String status) {
    switch (status) {
      case 'Aktif':
        return const Color(0xff003B73);
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'Aktif':
        return const Color(0xff003B73).withOpacity(0.1);
      case 'Selesai':
        return Colors.green.withOpacity(0.1);
      case 'Dibatalkan':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Aktif':
        return Icons.schedule_rounded;
      case 'Selesai':
        return Icons.check_circle_rounded;
      case 'Dibatalkan':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  void _lihatDetail(Map<String, dynamic> pesanan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(pesanan: pesanan),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff003B73),
        title: const Text(
          'Riwayat Pemesanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: [
            Tab(text: 'Aktif (${pesananAktif.length})'),
            Tab(text: 'Selesai (${pesananSelesai.length})'),
            Tab(text: 'Dibatalkan (${pesananDibatalkan.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(pesananAktif),
          _buildList(pesananSelesai),
          _buildList(pesananDibatalkan),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada pemesanan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pemesanan kamu akan muncul di sini',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) => _KartuPesanan(
        pesanan: list[i],
        statusColor: _statusColor(list[i]['status']),
        statusBgColor: _statusBgColor(list[i]['status']),
        statusIcon: _statusIcon(list[i]['status']),
        onTap: () => _lihatDetail(list[i]),
      ),
    );
  }
}

// ── KARTU PESANAN ──
class _KartuPesanan extends StatelessWidget {
  final Map<String, dynamic> pesanan;
  final Color statusColor;
  final Color statusBgColor;
  final IconData statusIcon;
  final VoidCallback onTap;

  const _KartuPesanan({
    required this.pesanan,
    required this.statusColor,
    required this.statusBgColor,
    required this.statusIcon,
    required this.onTap,
  });

  String _formatRupiah(int angka) {
    final str = angka.toString();
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
    final villa = pesanan['villa'] as Map;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header gambar + badge status
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    villa['image'],
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.35),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge status
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 12, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            pesanan['status'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nama villa di bawah gambar
                  Positioned(
                    bottom: 10,
                    left: 14,
                    right: 14,
                    child: Text(
                      villa['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black45)],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Lokasi + ID
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        villa['location'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        pesanan['id'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Check-in / Check-out
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F6FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CHECK-IN',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pesanan['checkIn'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CHECK-OUT',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  pesanan['checkOut'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'DURASI',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${pesanan['jumlahMalam']}m',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Total + tombol detail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            _formatRupiah(pesanan['total']),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff001B44),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: onTap,
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(
                            0xff003B73,
                          ).withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Lihat Detail',
                          style: TextStyle(
                            color: Color(0xff003B73),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── BOTTOM SHEET DETAIL ──
class _DetailSheet extends StatelessWidget {
  final Map<String, dynamic> pesanan;

  const _DetailSheet({required this.pesanan});

  String _formatRupiah(int angka) {
    final str = angka.toString();
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
    final villa = pesanan['villa'] as Map;
    final status = pesanan['status'] as String;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Pemesanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ID Pesanan + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pesanan['id'],
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: status == 'Aktif'
                        ? const Color(0xff003B73).withOpacity(0.1)
                        : status == 'Selesai'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: status == 'Aktif'
                          ? const Color(0xff003B73)
                          : status == 'Selesai'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Info villa
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    villa['image'],
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        villa['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        villa['location'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xff003B73),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            villa['rating'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Detail tabel
            _barisPesanan('Check-in', pesanan['checkIn']),
            _barisPesanan('Check-out', pesanan['checkOut']),
            _barisPesanan('Durasi', '${pesanan['jumlahMalam']} malam'),
            _barisPesanan('Jumlah tamu', '${pesanan['jumlahTamu']} tamu'),

            const Divider(height: 28),

            // Rincian biaya
            const Text(
              'Rincian Biaya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            _barisBiaya(
              '${_formatRupiah(int.parse(villa['price']))} × ${pesanan['jumlahMalam']} malam',
              _formatRupiah(
                int.parse(villa['price']) * (pesanan['jumlahMalam'] as int),
              ),
            ),
            _barisBiaya(
              'Service fee',
              _formatRupiah(
                pesanan['total'] -
                    int.parse(villa['price']) * (pesanan['jumlahMalam'] as int),
              ),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _formatRupiah(pesanan['total']),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff001B44),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tombol aksi
            if (status == 'Selesai')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.star_border_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Beri Ulasan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff003B73),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            if (status == 'Aktif')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                  label: const Text(
                    'Batalkan Pesanan',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _barisPesanan(String label, String nilai) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          nilai,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    ),
  );

  Widget _barisBiaya(String label, String nilai) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
        Text(nilai, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}
