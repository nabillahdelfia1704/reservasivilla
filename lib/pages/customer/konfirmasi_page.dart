import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pembayaran_page.dart';

class KonfirmasiPage extends StatefulWidget {
  final Map villa;
  final String tanggal;
  final int jumlahTamu;
  final int jumlahMalam;
  final int subtotal;
  final int serviceFee;
  final int total;

  const KonfirmasiPage({
    super.key,
    required this.villa,
    required this.tanggal,
    required this.jumlahTamu,
    required this.jumlahMalam,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
  });

  @override
  State<KonfirmasiPage> createState() => _KonfirmasiPageState();
}

class _KonfirmasiPageState extends State<KonfirmasiPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController namaDepanController = TextEditingController();
  final TextEditingController namaBelakangController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController promoController = TextEditingController();
  String? selectedNegara = 'Indonesia';
  String? pesanPromo;
  bool promoValid = false;
  int? diskonPersen;

  @override
  void dispose() {
    emailController.dispose();
    namaDepanController.dispose();
    namaBelakangController.dispose();
    noHpController.dispose();
    promoController.dispose();
    super.dispose();
  }

  void _cekPromo() {
    // Tambahkan logika validasi promo dari backend/API di sini
    setState(() {
      promoValid = false;
      pesanPromo = 'Kode promo tidak valid';
      diskonPersen = null;
    });
  }

  int get totalSetelahPromo {
    if (promoValid && diskonPersen != null) {
      return widget.total - (widget.total * diskonPersen! ~/ 100);
    }
    return widget.total;
  }

  void _lanjutPembayaran() {
    if (namaDepanController.text.trim().isEmpty ||
        namaBelakangController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        noHpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom yang wajib diisi')),
      );
      return;
    }

    if (noHpController.text.trim().length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor HP minimal 12 digit')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PembayaranPage(
          total: totalSetelahPromo,
          villa: widget.villa,
          tanggal: widget.tanggal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Konfirmasi Pesanan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── RINGKASAN VILLA ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffF5F6FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        widget.villa['image'].toString().startsWith('assets/')
                        ? Image.asset(
                            widget.villa['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.villa['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.villa['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.villa['location'],
                          style: const TextStyle(
                            color: Colors.black54,
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
                              widget.villa['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
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

            const SizedBox(height: 20),

            // ── RINCIAN BOOKING ──
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CHECK-IN',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.tanggal.split(' - ')[0],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CHECK-OUT',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.tanggal.split(' - ')[1],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24, color: Colors.grey.shade200),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TAMU',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.jumlahTamu} tamu',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DURASI',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.jumlahMalam} malam',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24, color: Colors.grey.shade200),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${widget.villa["price"]} × ${widget.jumlahMalam} malam',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Rp ${widget.subtotal}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Service fee', style: TextStyle(fontSize: 14)),
                      Text(
                        'Rp ${widget.serviceFee}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  // Tampilkan baris diskon kalau promo valid
                  if (promoValid && diskonPersen != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diskon ($diskonPersen%)',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '- Rp ${widget.total - totalSetelahPromo}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Divider(height: 24, color: Colors.grey.shade300),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Rp $totalSetelahPromo',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff001B44),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── KODE PROMO ──
            const Text(
              'Kode Promo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: promoController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode promo',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: pesanPromo == null
                          ? null
                          : Icon(
                              promoValid ? Icons.check_circle : Icons.cancel,
                              color: promoValid ? Colors.green : Colors.red,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _cekPromo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff003B73),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Pakai',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (pesanPromo != null) ...[
              const SizedBox(height: 6),
              Text(
                pesanPromo!,
                style: TextStyle(
                  fontSize: 13,
                  color: promoValid ? Colors.green : Colors.red,
                ),
              ),
            ],

            const SizedBox(height: 28),

            // ── FORM TAMU ──
            const Text(
              'Siapa tamu utamanya?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              '*Kolom ini harus diisi',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
            const SizedBox(height: 20),

            _buildTextField('Nama depan *', namaDepanController),
            _buildTextField('Nama belakang *', namaBelakangController),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(label: 'Email *'),
              ),
            ),

            _buildLabel('Negara tempat tinggal *'),
            DropdownButtonFormField<String>(
              value: selectedNegara,
              decoration: _inputDecoration(),
              items: ['Indonesia', 'Malaysia', 'Singapore'].map((v) {
                return DropdownMenuItem(value: v, child: Text(v));
              }).toList(),
              onChanged: (v) => setState(() => selectedNegara = v),
            ),

            const SizedBox(height: 16),
            const Text(
              'Nomor HP *',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: noHpController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: _inputDecoration(
                label: 'Nomor HP *',
                hint: 'Contoh: 081234567890',
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Pastikan informasi kontak Anda sudah benar.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // ── TOMBOL LANJUT ──
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _lanjutPembayaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff003B73),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lanjut ke Pembayaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                "You won't be charged yet",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(label: label, hint: hint),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  InputDecoration _inputDecoration({String? label, String? hint}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );
}
