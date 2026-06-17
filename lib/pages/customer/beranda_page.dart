import 'package:flutter/material.dart';
import '../data/data_villa.dart';
import '../auth/customer/auth_service.dart';
import 'search_page.dart';
import 'detail_villa_page.dart';
import 'profile_page.dart';
import 'riwayat_page.dart';
import 'favorite_page.dart';
import 'promo_detail_page.dart';
import '../auth/customer/login_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String formatRupiah(String price) {
    final angka = int.tryParse(price.replaceAll('.', '')) ?? 0;
    final str = angka.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join('');
  }

  String lokasi = "Kota, tujuan, atau nama hotel";
  DateTimeRange? selectedRange;
  String displayTanggal = "Pilih Tanggal";
  int jumlahTamu = 0;
  int selectedNav = 0;

  late List<bool> favoriteList;

  @override
  void initState() {
    super.initState();
    favoriteList = List.filled(villaList.length, false);
  }

  Widget _buildBody() {
    switch (selectedNav) {
      case 1:
        return const RiwayatPage();
      case 2:
        return FavoritPage(
          favoriteList: favoriteList,
          displayTanggal: displayTanggal,
          jumlahTamu: jumlahTamu,
        );
      case 3:
        if (!AuthService.isLoggedIn) {
          return _buildLoginPrompt();
        }
        return ProfilePage(onLogout: () => setState(() {}));
      default:
        return _buildBeranda();
    }
  }

  // prompt login jika belum masuk
  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Color(0xff003B73)),
            const SizedBox(height: 24),
            const Text(
              "Silakan login terlebih dahulu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Masuk untuk melihat profil dan mengelola akun kamu",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff003B73),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F7),
      body: _buildBody(),
      // navbar bawah
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 50),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_filled, 0),
            _navItem(Icons.receipt_long, 1),
            _navItem(Icons.favorite_border, 2),
            _navItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBeranda() {
    return SafeArea(
      child: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // header biru
              Container(
                height: 430,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff003B73),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage('assets/img/logo.png'),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Villaku",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // box search
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // input destinasi
                      GestureDetector(
                        onTap: () async {
                          final range =
                              selectedRange ??
                              DateTimeRange(
                                start: DateTime.now(),
                                end: DateTime.now().add(
                                  const Duration(days: 1),
                                ),
                              );
                          final hasil = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SearchPage(
                                tanggal: range,
                                jumlahTamu: jumlahTamu,
                                fromBeranda: true,
                              ),
                            ),
                          );
                          if (hasil != null) {
                            setState(() => lokasi = hasil);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                Icons.search,
                                color: Color(0xff003B73),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Pilih Destinasi",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    lokasi,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      // input tanggal
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedRange = picked;
                              displayTanggal =
                                  "${picked.start.day}/${picked.start.month}/${picked.start.year}"
                                  " - "
                                  "${picked.end.day}/${picked.end.month}/${picked.end.year}";
                            });
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                Icons.receipt_long,
                                color: Color(0xff003B73),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Tanggal Menginap",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    displayTanggal,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff003B73),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      // input jumlah tamu
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => StatefulBuilder(
                              builder: (ctx, setModal) => Container(
                                height: 230,
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Jumlah Tamu",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 35),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (jumlahTamu > 0) {
                                              setModal(() => jumlahTamu--);
                                              setState(() {});
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            size: 42,
                                            color: Color(0xff003B73),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          "$jumlahTamu",
                                          style: const TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        IconButton(
                                          onPressed: () {
                                            setModal(() => jumlahTamu++);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.add_circle,
                                            size: 42,
                                            color: Color(0xff003B73),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                Icons.people_outline,
                                color: Color(0xff003B73),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Informasi Pesanan",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    jumlahTamu == 0
                                        ? "Tambahkan Tamu"
                                        : "$jumlahTamu Tamu",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff003B73),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // tombol cari
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (lokasi == "Kota, tujuan, atau nama hotel") {
                              _snack("Silakan pilih destinasi terlebih dahulu");
                              return;
                            }
                            if (displayTanggal == "Pilih Tanggal") {
                              _snack("Silakan pilih tanggal menginap");
                              return;
                            }
                            if (jumlahTamu == 0) {
                              _snack("Silakan tambahkan jumlah tamu");
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchPage(
                                  tanggal: selectedRange!,
                                  jumlahTamu: jumlahTamu,
                                  lokasi: lokasi,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff003B73),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            "Cari Kamar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),
                const Divider(),
                const SizedBox(height: 5),
                const Text(
                  "Promo & Diskon",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff003B73),
                  ),
                ),
                const SizedBox(height: 18),
                // list promo horizontal
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: promoList.length,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PromoDetailPage(promo: promoList[index]),
                        ),
                      ),
                      child: Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                            image: AssetImage(promoList[index]['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 5),
                const Text(
                  "Explore",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff003B73),
                  ),
                ),
                const SizedBox(height: 20),
                // list villa
                ListView.builder(
                  itemCount: villaList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final villa = villaList[index];
                    final String image = villa["image"]?.toString() ?? '';
                    final String name =
                        villa["name"]?.toString() ?? 'Nama tidak tersedia';
                    final String lokasi =
                        villa["lokasi"]?.toString() ?? 'Lokasi tidak tersedia';
                    final String rating = villa["rating"]?.toString() ?? '0.0';
                    final String price = villa["price"]?.toString() ?? '0';
                    final bool isAsset = image.startsWith("assets/");

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailVillaPage(
                            villa: villa,
                            tanggal: displayTanggal == "Pilih Tanggal"
                                ? "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().add(const Duration(days: 1)).day}/${DateTime.now().add(const Duration(days: 1)).month}/${DateTime.now().add(const Duration(days: 1)).year}"
                                : displayTanggal,
                            jumlahTamu: jumlahTamu == 0 ? 1 : jumlahTamu,
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: image.isEmpty
                                      ? Container(
                                          height: 240,
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
                                          height: 240,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          image,
                                          height: 240,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                // tombol favorit
                                Positioned(
                                  top: 15,
                                  right: 15,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!AuthService.isLoggedIn) {
                                        setState(() => selectedNav = 2);
                                        return;
                                      }
                                      setState(
                                        () => favoriteList[index] =
                                            !favoriteList[index],
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      child: Icon(
                                        favoriteList[index]
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favoriteList[index]
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lokasi,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rp ${formatRupiah(price)} / malam",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _navItem(IconData icon, int index) {
    final isActive = selectedNav == index;
    return GestureDetector(
      onTap: () => setState(() => selectedNav = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xffD9E7F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xff003B73) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
