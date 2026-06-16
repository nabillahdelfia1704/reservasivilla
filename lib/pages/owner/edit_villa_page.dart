import 'package:flutter/material.dart';
// Asumsikan data_villa.dart adalah tempat kamu menyimpan villaList
// import 'data_villa.dart';

class EditVillaPage extends StatefulWidget {
  final Map<String, dynamic> villaData;

  const EditVillaPage({super.key, required this.villaData});

  @override
  State<EditVillaPage> createState() => _EditVillaPageState();
}

class _EditVillaPageState extends State<EditVillaPage> {
  // Controller
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController addressController;
  late TextEditingController priceController;
  late TextEditingController descController;

  bool isActive = true; // Status Aktif/Nonaktif

  @override
  void initState() {
    super.initState();
    // Mengisi field dengan data dari data villa
    nameController = TextEditingController(text: widget.villaData['name']);
    locationController = TextEditingController(
      text: widget.villaData['lokasi'],
    );
    addressController = TextEditingController(
      text: widget.villaData['alamat'] ?? "",
    );
    priceController = TextEditingController(text: widget.villaData['price']);
    descController = TextEditingController(
      text: widget.villaData['description'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text(
          "Edit Villa Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Logika Hapus Villa
              // villaList.remove(widget.villaData);
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Gambar Villa
          Container(
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.villaData['image']),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Status
          const Text(
            "Status Villa",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              _buildStatusButton("Aktif", true),
              _buildStatusButton("Nonaktif", false),
            ],
          ),
          const SizedBox(height: 10),

          // Form Input
          _buildTextField("Nama Villa", nameController),
          _buildTextField("Lokasi", locationController),
          _buildTextField("Alamat Lengkap Villa", addressController),
          _buildTextField("Harga per Malam", priceController),
          _buildTextField("Deskripsi Villa", descController, maxLines: 4),

          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff003B73),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              // Update data
              widget.villaData['name'] = nameController.text;
              widget.villaData['lokasi'] = locationController.text;
              widget.villaData['alamat'] = addressController.text;
              widget.villaData['price'] = priceController.text;
              widget.villaData['description'] = descController.text;
              Navigator.pop(context);
            },
            child: const Text(
              "Simpan Perubahan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String title, bool status) => Expanded(
    child: InkWell(
      onTap: () => setState(() => isActive = status),
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive == status
              ? const Color(0xff003B73)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive == status ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 8),
        child: Text(label),
      ),
      TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ],
  );
}
