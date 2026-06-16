import 'package:flutter/material.dart';

class TambahVillaPage extends StatefulWidget {
  const TambahVillaPage({super.key});

  @override
  State<TambahVillaPage> createState() => _TambahVillaPageState();
}

class _TambahVillaPageState extends State<TambahVillaPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController =
      TextEditingController(); // Lokasi (Puncak)
  final TextEditingController addressController =
      TextEditingController(); // Alamat Lengkap
  final TextEditingController priceController = TextEditingController();
  final TextEditingController guestController = TextEditingController();
  final TextEditingController bedController = TextEditingController();
  final TextEditingController bathController = TextEditingController();

  bool isChecked = false;
  bool _isFotoUploaded = false;
  bool _isFileUploaded = false;

  final Map<String, IconData> fasilitasConfig = {
    "WiFi": Icons.wifi,
    "AC": Icons.ac_unit,
    "Pool": Icons.pool,
    "Parking": Icons.local_parking,
    "Kitchen": Icons.kitchen,
  };

  Map<String, bool> fasilitasTerpilih = {
    "WiFi": false,
    "AC": false,
    "Pool": false,
    "Parking": false,
    "Kitchen": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text(
          "Tambah Villa Baru",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle("Foto Villa"),
          _buildUploadBox(
            "Pilih Foto",
            Icons.camera_alt,
            _isFotoUploaded,
            () => setState(() => _isFotoUploaded = true),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("Dokumen Pendukung"),
          _buildUploadBox(
            "Klik untuk unggah berkas PDF atau JPG",
            Icons.file_present,
            _isFileUploaded,
            () => setState(() => _isFileUploaded = true),
          ),
          const SizedBox(height: 20),

          _buildSectionTitle("Informasi Dasar"),
          _buildTextField(
            "Nama Villa",
            "Contoh: Villa Amanah Kencana",
            nameController,
          ),
          _buildTextField(
            "Lokasi (Area/Kota)",
            "Contoh: Puncak",
            areaController,
          ),
          _buildTextField(
            "Alamat Lengkap",
            "Contoh: Jl. Raya Puncak No.123, Bogor",
            addressController,
          ),
          _buildTextField("Harga per Malam (Rp)", "1.500.000", priceController),

          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildTextField("Tamu", "10", guestController)),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField("Kamar", "5", bedController)),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTextField("Kamar Mandi", "3", bathController),
              ),
            ],
          ),

          const SizedBox(height: 25),
          _buildSectionTitle("Fasilitas Villa"),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: fasilitasConfig.entries
                .map(
                  (e) => _buildFacilityChip(
                    e.key,
                    e.value,
                    fasilitasTerpilih[e.key]!,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 30),
          CheckboxListTile(
            title: const Text(
              "Saya menyatakan bahwa semua informasi adalah benar",
            ),
            value: isChecked,
            onChanged: (val) => setState(() => isChecked = val!),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff003B73),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: isChecked
                ? () {
                    if (!_isFotoUploaded || !_isFileUploaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mohon lengkapi dokumen!"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                      Map<String, dynamic> dataBaru = {
                        "name": nameController.text,
                        "lokasi": areaController
                            .text, // Gunakan ini untuk filter di Beranda
                        "address":
                            addressController.text, // Gunakan ini untuk detail
                        "price": priceController.text,
                        "guests": int.tryParse(guestController.text) ?? 0,
                        "bedroom": int.tryParse(bedController.text) ?? 0,
                        "bathroom": int.tryParse(bathController.text) ?? 0,
                        "wifi": fasilitasTerpilih["WiFi"],
                        "ac": fasilitasTerpilih["AC"],
                        "pool": fasilitasTerpilih["Pool"],
                        "parkir": fasilitasTerpilih["Parking"],
                        "dapur": fasilitasTerpilih["Kitchen"],
                        "image": "assets/img/promo2.jpeg",
                      };
                      Navigator.pop(context, dataBaru);
                    }
                  }
                : null,
            child: const Text(
              "Daftarkan Villa",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildUploadBox(
    String label,
    IconData icon,
    bool isUploaded,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isUploaded ? Colors.green : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            isUploaded ? Icons.check_circle : icon,
            size: 40,
            color: isUploaded ? Colors.green : Colors.grey,
          ),
          Text(isUploaded ? "Berhasil dipilih" : label),
        ],
      ),
    ),
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
  );

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 8),
        child: Text(label),
      ),
      TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ],
  );

  Widget _buildFacilityChip(
    String label,
    IconData icon,
    bool isSelected,
  ) => InkWell(
    onTap: () => setState(() => fasilitasTerpilih[label] = !isSelected),
    child: Container(
      width: 90,
      height: 80,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xff003B73).withValues(alpha: 0.1)
            : Colors.white,
        border: Border.all(
          color: isSelected ? const Color(0xff003B73) : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xff003B73) : Colors.grey),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}
