import 'package:flutter/material.dart';
import '../data/data_villa.dart'; // ← kota dari data terpusat

class FilterVillaSheet extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final bool wifi;
  final bool ac;
  final bool kolamRenang;
  final bool parkir;
  final bool bakMandi;
  final double selectedRating;
  final String selectedCity;
  final int? selectedGuests;

  final Function(double, double) onPriceChanged;
  final Function(bool, bool, bool, bool, bool) onFasilitasChanged;
  final Function(double) onRatingChanged;
  final Function(String) onCityChanged;
  final Function(int?) onGuestsChanged;

  const FilterVillaSheet({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.wifi,
    required this.ac,
    required this.kolamRenang,
    required this.parkir,
    required this.bakMandi,
    required this.selectedRating,
    required this.selectedCity,
    required this.selectedGuests,
    required this.onPriceChanged,
    required this.onFasilitasChanged,
    required this.onRatingChanged,
    required this.onCityChanged,
    required this.onGuestsChanged,
  });

  @override
  State<FilterVillaSheet> createState() => _FilterVillaSheetState();
}

class _FilterVillaSheetState extends State<FilterVillaSheet> {
  late double minPrice;
  late double maxPrice;
  late bool wifi, ac, kolamRenang, parkir, bakMandi;
  late double selectedRating;
  late String selectedCity;
  late int? selectedGuests;

  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;
    wifi = widget.wifi;
    ac = widget.ac;
    kolamRenang = widget.kolamRenang;
    parkir = widget.parkir;
    bakMandi = widget.bakMandi;
    selectedRating = widget.selectedRating;
    selectedCity = widget.selectedCity;
    selectedGuests = widget.selectedGuests;

    _minController.text = minPrice == 0 ? '' : minPrice.toInt().toString();
    _maxController.text = maxPrice == 5000000
        ? ''
        : maxPrice.toInt().toString();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _divider() =>
      const Divider(height: 32, thickness: 1, color: Color(0xFFEEEEEE));

  Widget _checkbox(String label, bool value, Function(bool) onChanged) => Row(
    children: [
      SizedBox(
        width: 24,
        height: 24,
        child: Checkbox(
          value: value,
          onChanged: (v) => onChanged(v!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: const Color(0xFF3D7BF4),
        ),
      ),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 14)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 22),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'FILTER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
            const SizedBox(height: 20),

            // ── Jumlah Tamu ──
            _sectionTitle('Jumlah Tamu'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [1, 2, 3, 4, 5, 6, 7, 8].map((g) {
                final isSelected = selectedGuests == g;
                return GestureDetector(
                  onTap: () =>
                      setState(() => selectedGuests = isSelected ? null : g),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3D7BF4)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3D7BF4)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$g',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            _divider(),

            // ── Batas Harga ──
            _sectionTitle('Batas Harga'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Minimal',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                    ),
                    onChanged: (v) =>
                        setState(() => minPrice = double.tryParse(v) ?? 0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 20,
                    height: 1.5,
                    color: Colors.grey.shade400,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Maksimal',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                    ),
                    onChanged: (v) => setState(
                      () => maxPrice = double.tryParse(v) ?? 5000000,
                    ),
                  ),
                ),
              ],
            ),

            _divider(),

            // ── Fasilitas ──
            _sectionTitle('Fasilitas'),
            Row(
              children: [
                Expanded(
                  child: _checkbox(
                    'Wifi',
                    wifi,
                    (v) => setState(() => wifi = v),
                  ),
                ),
                Expanded(
                  child: _checkbox(
                    'Parkir',
                    parkir,
                    (v) => setState(() => parkir = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _checkbox('AC', ac, (v) => setState(() => ac = v)),
                ),
                Expanded(
                  child: _checkbox(
                    'Bak mandi',
                    bakMandi,
                    (v) => setState(() => bakMandi = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _checkbox(
              'Kolam Renang',
              kolamRenang,
              (v) => setState(() => kolamRenang = v),
            ),

            _divider(),

            // ── Rating ──
            _sectionTitle('Rating'),
            ...[4.9, 4.8, 4.7].map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => setState(
                    () => selectedRating = selectedRating == r ? 0 : r,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: selectedRating == r,
                          onChanged: (v) =>
                              setState(() => selectedRating = v! ? r : 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          activeColor: const Color(0xFF3D7BF4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('$r', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFC107),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            _divider(),

            // ── Kota dari kotaList (villa_data.dart) ──
            _sectionTitle('Kota'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kotaList.map((city) {
                // ← pakai kotaList dari villa_data
                final isSelected = selectedCity == city;
                return GestureDetector(
                  onTap: () => setState(() => selectedCity = city),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3D7BF4)
                            : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      city,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? const Color(0xFF3D7BF4)
                            : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // ── Tombol Cari ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onPriceChanged(minPrice, maxPrice);
                  widget.onFasilitasChanged(
                    wifi,
                    ac,
                    kolamRenang,
                    parkir,
                    bakMandi,
                  );
                  widget.onRatingChanged(selectedRating);
                  widget.onCityChanged(selectedCity);
                  widget.onGuestsChanged(selectedGuests);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D7BF4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Cari kamar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
