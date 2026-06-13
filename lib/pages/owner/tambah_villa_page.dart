import 'package:flutter/material.dart';

class TambahVillaPage extends StatefulWidget {
  const TambahVillaPage({super.key});

  @override
  State<TambahVillaPage> createState() => _TambahVillaPageState();
}

class _TambahVillaPageState extends State<TambahVillaPage> {
  // Controller untuk mengambil inputan
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isChecked = false;

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
          _buildSectionTitle("Informasi Dasar"),

          // Memanggil TextField dengan Controller
          _buildTextField(
            "Nama Villa",
            "Contoh: Villa Amanah Kencana",
            nameController,
          ),
          _buildTextField(
            "Alamat Lengkap Villa",
            "Contoh: Puncak, Bogor",
            locController,
          ),
          _buildTextField("Harga per Malam (Rp)", "1.500.000", priceController),

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

          // Checkbox Persetujuan
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
                    // Paket data yang dikirim balik ke BerandaPage
                    Map<String, dynamic> dataBaru = {
                      "name": nameController.text,
                      "location": locController.text,
                      "price": priceController.text,
                      "rating": "5.0",
                    };

                    Navigator.pop(context, dataBaru); // Mengirim data
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
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 8),
          child: Text(label),
        ),
        TextField(
          controller: controller, // Menghubungkan controller ke TextField
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

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
            ? const Color(0xff003B73).withOpacity(0.1)
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
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}
