import 'package:flutter/material.dart';
import '../data/data_villa.dart';
import 'detail_villa_page.dart';
import 'filter_villa_sheet.dart';

class SearchPage extends StatefulWidget {
  final DateTimeRange tanggal;
  final int jumlahTamu;
  final bool fromBeranda;
  final String? lokasi;

  const SearchPage({
    super.key,
    required this.tanggal,
    required this.jumlahTamu,
    this.fromBeranda = false,
    this.lokasi,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum _ViewMode { search, villaList }

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredResults = [];

  _ViewMode _viewMode = _ViewMode.search;
  String _selectedCity = '';
  String? selectedCity;
  late int? selectedGuests;

  double minPrice = 0;
  double maxPrice = 5000000;
  bool wifi = false;
  bool ac = false;
  bool kolamRenang = false;
  bool parkir = false;
  bool bakMandi = false;
  double selectedRating = 0;

  @override
  void initState() {
    super.initState();
    selectedGuests = widget.jumlahTamu > 0 ? widget.jumlahTamu : null;

    if (widget.lokasi != null && widget.lokasi!.isNotEmpty) {
      _selectedCity = widget.lokasi!;
      selectedCity = widget.lokasi;
      _viewMode = _ViewMode.villaList;
    }
  }

  bool isVillaAvailable(Map<String, dynamic> villa) {
    final bookings = bookingList
        .where((b) => b["villaId"] == villa["id"])
        .toList();
    for (var b in bookings) {
      DateTime bookedStart = b["startDate"];
      DateTime bookedEnd = b["endDate"];
      if (widget.tanggal.start.isBefore(bookedEnd) &&
          widget.tanggal.end.isAfter(bookedStart)) {
        return false;
      }
    }
    return true;
  }

  void searchData(String keyword) {
    if (keyword.trim().isEmpty) {
      setState(() => filteredResults = []);
      return;
    }

    final q = keyword.toLowerCase();
    final List<Map<String, dynamic>> hasil = [];

    for (final kota in kotaList) {
      if (kota.toLowerCase().contains(q)) {
        hasil.add({"type": "kota", "label": kota});
      }
    }

    for (final villa in villaList) {
      // ── Null-safety fix ──
      final String name = villa["name"]?.toString().toLowerCase() ?? '';
      final String lokasi = villa["lokasi"]?.toString().toLowerCase() ?? '';
      final String city = villa["city"]?.toString().toLowerCase() ?? '';
      final int kapasitasVilla = villa["guests"] ?? 0;

      bool cocokKeyword =
          name.contains(q) || lokasi.contains(q) || city.contains(q);

      bool pasTamu =
          widget.jumlahTamu == 0 || kapasitasVilla == widget.jumlahTamu;

      bool tersedia = isVillaAvailable(villa);

      if (cocokKeyword && pasTamu && tersedia) {
        hasil.add({"type": "villa", "villa": villa});
      }
    }

    setState(() => filteredResults = hasil);
  }

  void _onTapResult(Map<String, dynamic> item) {
    final String city = item["type"] == "kota"
        ? item["label"]
        : item["villa"]["city"]?.toString() ?? '';

    if (widget.fromBeranda) {
      Navigator.pop(context, city);
      return;
    }

    setState(() {
      _selectedCity = city;
      selectedCity = city;
      _viewMode = _ViewMode.villaList;
    });
  }

  List<Map<String, dynamic>> get filteredVillas {
    List<Map<String, dynamic>> villas = List.from(villaList);

    villas = villas.where((v) {
      return (selectedCity ?? _selectedCity).toLowerCase() ==
          (v["city"]?.toString().toLowerCase() ?? '');
    }).toList();

    // ── Null-safety fix: price ──
    villas = villas.where((v) {
      final price = int.tryParse(v["price"]?.toString() ?? '') ?? 0;
      return price >= minPrice && price <= maxPrice;
    }).toList();

    // ── Null-safety fix: rating ──
    villas = villas.where((v) {
      final rating = double.tryParse(v["rating"]?.toString() ?? '') ?? 0.0;
      return rating >= selectedRating;
    }).toList();

    if (selectedGuests != null) {
      villas = villas
          .where((v) => (v["guests"] ?? 0) <= selectedGuests!)
          .toList();
    }

    if (wifi) villas = villas.where((v) => v["wifi"] == true).toList();
    if (ac) villas = villas.where((v) => v["ac"] == true).toList();
    if (kolamRenang) villas = villas.where((v) => v["pool"] == true).toList();
    if (parkir) villas = villas.where((v) => v["parkir"] == true).toList();
    if (bakMandi) villas = villas.where((v) => v["bakMandi"] == true).toList();

    return villas;
  }

  @override
  Widget build(BuildContext context) {
    return _viewMode == _ViewMode.search
        ? _buildSearchView()
        : _buildVillaListView();
  }

  Widget _buildSearchView() {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Cari Destinasi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: searchData,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Cari kota atau villa...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          searchData('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredResults.isEmpty
                  ? Center(
                      child: Text(
                        searchController.text.isEmpty
                            ? "Ketik untuk mencari kota atau villa"
                            : "Tidak ada hasil untuk pencarian tersebut",
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredResults.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      itemBuilder: (context, index) {
                        final item = filteredResults[index];
                        final isKota = item["type"] == "kota";

                        if (isKota) {
                          return ListTile(
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_city,
                                color: Color(0xFF3D7BF4),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              item["label"]?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text(
                              "Kota",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () => _onTapResult(item),
                          );
                        } else {
                          final villa = item["villa"] as Map;
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              villa["name"]?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "Rp ${villa["price"]?.toString() ?? '0'} / malam · 👥 ${villa["guests"]?.toString() ?? '0'} Tamu",
                            ),
                            onTap: () => _onTapResult(item),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVillaListView() {
    final villas = filteredVillas;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.lokasi != null) {
                        Navigator.pop(context);
                      } else {
                        setState(() => _viewMode = _ViewMode.search);
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${selectedCity ?? _selectedCity} (${villas.length})",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Hasil pencarian villa",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _openSearchSheet,
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: _openFilterSheet,
                  ),
                ],
              ),
            ),
            Expanded(
              child: villas.isEmpty
                  ? const Center(child: Text("Tidak ada villa yang tersedia"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: villas.length,
                      itemBuilder: (context, index) {
                        final villa = villas[index];

                        // ── Null-safety fix ──
                        final String image = villa["image"]?.toString() ?? '';
                        final String name =
                            villa["name"]?.toString() ?? 'Nama tidak tersedia';
                        final String lokasi = villa["lokasi"]?.toString() ?? '';
                        final String rating =
                            villa["rating"]?.toString() ?? '0.0';
                        final String price = villa["price"]?.toString() ?? '0';
                        final bool villaIsAsset = image.startsWith("assets/");

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailVillaPage(
                                villa: villa,
                                tanggal:
                                    "${widget.tanggal.start.day}/${widget.tanggal.start.month}/${widget.tanggal.start.year}"
                                    " - "
                                    "${widget.tanggal.end.day}/${widget.tanggal.end.month}/${widget.tanggal.end.year}",
                                jumlahTamu: widget.jumlahTamu == 0
                                    ? 1
                                    : widget.jumlahTamu,
                              ),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: image.isEmpty
                                      ? Container(
                                          height: 220,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : villaIsAsset
                                      ? Image.asset(
                                          image,
                                          height: 220,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          image,
                                          height: 220,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(lokasi),
                                Text("$rating ⭐"),
                                Text("Rp $price / malam"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => FilterVillaSheet(
          minPrice: minPrice,
          maxPrice: maxPrice,
          wifi: wifi,
          ac: ac,
          kolamRenang: kolamRenang,
          parkir: parkir,
          bakMandi: bakMandi,
          selectedRating: selectedRating,
          selectedCity: selectedCity ?? _selectedCity,
          selectedGuests: selectedGuests,
          onPriceChanged: (min, max) => setState(() {
            minPrice = min;
            maxPrice = max;
          }),
          onFasilitasChanged: (w, a, k, p, b) => setState(() {
            wifi = w;
            ac = a;
            kolamRenang = k;
            parkir = p;
            bakMandi = b;
          }),
          onRatingChanged: (r) => setState(() => selectedRating = r),
          onCityChanged: (c) => setState(() => selectedCity = c),
          onGuestsChanged: (g) => setState(() => selectedGuests = g),
        ),
      ),
    );
  }

  void _openSearchSheet() {
    final cityController = TextEditingController(
      text: selectedCity ?? _selectedCity,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Kota",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: "Masukkan kota",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => selectedCity = cityController.text);
                  Navigator.pop(context);
                },
                child: const Text("Terapkan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
