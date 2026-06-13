import 'package:flutter/material.dart';
import '../data/data_villa.dart';
import '../auth/auth_service.dart';
import 'search_page.dart';
import 'detail_villa_page.dart';
import 'profile_page.dart';
import '../auth/login_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F7),
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Header biru ──
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
                            backgroundImage: AssetImage(
                              'assets/img/profile.jpg',
                            ),
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

                // ── Search card ──
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
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ── Destinasi (ketik bebas, buka SearchPage) ──
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

                            // Buka SearchPage untuk ketik kota, lalu balik ke beranda
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

                        // ── Tanggal ──
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
                                  Icons.calendar_month_outlined,
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

                        // ── Jumlah tamu ──
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => StatefulBuilder(
                                builder: (ctx, setModal) => Container(
                                  height: 230,
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                        // ── Tombol Cari Kamar ──
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (lokasi == "Kota, tujuan, atau nama hotel") {
                                _snack(
                                  "Silakan pilih destinasi terlebih dahulu",
                                );
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

            // ── Konten bawah ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 45),
                  const Divider(),
                  const SizedBox(height: 5),

                  // Promo
                  const Text(
                    "Promo & Diskon",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff003B73),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: promoList.length,
                      itemBuilder: (_, index) => Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                            image: AssetImage(promoList[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 5),

                  // Populer
                  const Text(
                    "Populer",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff003B73),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ListView.builder(
                    itemCount: villaList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final villa = villaList[index];
                      final bool isAsset = villa["image"].toString().startsWith(
                        "assets/",
                      );

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailVillaPage(
                              villa: villa,
                              tanggal: displayTanggal == "Pilih Tanggal"
                                  ? "01/01/2025 - 02/01/2025"
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
                                    child: isAsset
                                        ? Image.asset(
                                            villa["image"],
                                            height: 240,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            villa["image"],
                                            height: 240,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    right: 15,
                                    child: GestureDetector(
                                      onTap: () => setState(
                                        () => favoriteList[index] =
                                            !favoriteList[index],
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white
                                            .withOpacity(0.7),
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
                                villa["name"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                villa["location"],
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
                                    villa["rating"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Rp ${villa["price"]} / malam",
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
      ),

      // ── Bottom nav ──
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 50),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_filled, 0),
            _navItem(Icons.calendar_month_outlined, 1),
            _navItem(Icons.favorite_border, 2),
            _navItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _navItem(IconData icon, int index) {
    final isActive = selectedNav == index;
    return GestureDetector(
      onTap: () {
        if (index == 3) {
          // Tap profile → cek login
          if (AuthService.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ).then((_) => setState(() {})); // refresh setelah logout
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
          return;
        }
        setState(() => selectedNav = index);
      },
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
