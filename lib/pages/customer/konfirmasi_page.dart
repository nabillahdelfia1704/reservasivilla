import 'package:flutter/material.dart';
import 'pembayaran_page.dart';
import '../auth/customer/auth_service.dart';

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
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user != null) {
      final namaLengkap = user['nama_lengkap']?.toString() ?? '';
      final namaParts = namaLengkap.trim().split(' ');
      namaDepanController.text = namaParts.first;
      namaBelakangController.text = namaParts.length > 1
          ? namaParts.sublist(1).join(' ')
          : '';
      emailController.text = user['email']?.toString() ?? '';
      noHpController.text = user['no_hp']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    namaDepanController.dispose();
    namaBelakangController.dispose();
    noHpController.dispose();
    promoController.dispose();
    super.dispose();
  }

  String formatRupiah(int angka) {
    final str = angka.toString();
    final buffer = StringBuffer();
    int counter = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (counter > 0 && counter % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      counter++;
    }
    return buffer.toString().split('').reversed.join('');
  }

  void _cekPromo() {
    setState(() {
      if (promoController.text.toUpperCase() == 'DISKON10') {
        promoValid = true;
        pesanPromo = 'Kode promo berhasil digunakan!';
        diskonPersen = 10;
      } else {
        promoValid = false;
        pesanPromo = 'Kode promo tidak valid';
        diskonPersen = null;
      }
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

    if (noHpController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor HP minimal 10 digit')),
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
          pajak: 'Rp ${formatRupiah(widget.serviceFee)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String image = widget.villa['image']?.toString() ?? '';
    final String name =
        widget.villa['name']?.toString() ?? 'Nama tidak tersedia';
    final String location = widget.villa['location']?.toString() ?? '';
    final String rating = widget.villa['rating']?.toString() ?? '0.0';
    final String price = widget.villa['price']?.toString() ?? '0';
    final bool isAsset = image.startsWith('assets/');

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
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image.isEmpty
                        ? Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                          )
                        : isAsset
                        ? Image.asset(
                            image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            image,
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
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xff003B73),
                              size: 14,
                            ),
                            Text(
                              " $rating",
                              style: const TextStyle(
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
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    "CHECK-IN",
                    widget.tanggal.split(' - ')[0],
                    "CHECK-OUT",
                    widget.tanggal.split(' - ')[1],
                  ),
                  Divider(height: 24, color: Colors.grey.shade200),
                  _buildDetailRow(
                    "TAMU",
                    "${widget.jumlahTamu} tamu",
                    "DURASI",
                    "${widget.jumlahMalam} malam",
                  ),
                  Divider(height: 24, color: Colors.grey.shade200),
                  _buildCostRow(
                    'Rp ${formatRupiah(int.tryParse(price.replaceAll(".", "")) ?? 0)} × ${widget.jumlahMalam} malam',
                    'Rp ${formatRupiah(widget.subtotal)}',
                  ),
                  _buildCostRow(
                    'pajak',
                    'Rp ${formatRupiah(widget.serviceFee)}',
                  ),
                  if (promoValid)
                    _buildCostRow(
                      'Diskon ($diskonPersen%)',
                      '- Rp ${formatRupiah(widget.total - totalSetelahPromo)}',
                      isDiscount: true,
                    ),
                  _buildCostRow(
                    'Total',
                    'Rp ${formatRupiah(totalSetelahPromo)}',
                    isBold: true,
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
                    decoration: _inputDecoration(hint: 'Masukkan kode promo'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _cekPromo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff003B73),
                    padding: const EdgeInsets.all(18),
                  ),
                  child: const Text(
                    'Pakai',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            if (pesanPromo != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  pesanPromo!,
                  style: TextStyle(
                    color: promoValid ? Colors.green : Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 28),
            const Text(
              'Siapa tamu utamanya?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Data diisi otomatis dari akun kamu. Ubah jika memesan untuk orang lain.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            _buildTextField('Nama depan *', namaDepanController),
            _buildTextField('Nama belakang *', namaBelakangController),
            _buildTextField('Email *', emailController),
            _buildLabel('Negara tempat tinggal *'),
            DropdownButtonFormField<String>(
              initialValue: selectedNegara,
              decoration: _inputDecoration(),
              items: [
                'Afghanistan',
                'Albania',
                'Algeria',
                'Andorra',
                'Angola',
                'Argentina',
                'Armenia',
                'Australia',
                'Austria',
                'Azerbaijan',
                'Bahrain',
                'Bangladesh',
                'Belarus',
                'Belgium',
                'Bolivia',
                'Bosnia and Herzegovina',
                'Brazil',
                'Brunei',
                'Bulgaria',
                'Cambodia',
                'Cameroon',
                'Canada',
                'Chile',
                'China',
                'Colombia',
                'Croatia',
                'Cuba',
                'Cyprus',
                'Czech Republic',
                'Denmark',
                'Ecuador',
                'Egypt',
                'Estonia',
                'Ethiopia',
                'Finland',
                'France',
                'Georgia',
                'Germany',
                'Ghana',
                'Greece',
                'Guatemala',
                'Hungary',
                'India',
                'Indonesia',
                'Iran',
                'Iraq',
                'Ireland',
                'Israel',
                'Italy',
                'Japan',
                'Jordan',
                'Kazakhstan',
                'Kenya',
                'Kuwait',
                'Kyrgyzstan',
                'Laos',
                'Latvia',
                'Lebanon',
                'Libya',
                'Lithuania',
                'Luxembourg',
                'Malaysia',
                'Maldives',
                'Mexico',
                'Moldova',
                'Mongolia',
                'Morocco',
                'Myanmar',
                'Nepal',
                'Netherlands',
                'New Zealand',
                'Nigeria',
                'North Korea',
                'Norway',
                'Oman',
                'Pakistan',
                'Palestine',
                'Panama',
                'Peru',
                'Philippines',
                'Poland',
                'Portugal',
                'Qatar',
                'Romania',
                'Russia',
                'Saudi Arabia',
                'Serbia',
                'Singapore',
                'Slovakia',
                'Slovenia',
                'Somalia',
                'South Africa',
                'South Korea',
                'Spain',
                'Sri Lanka',
                'Sudan',
                'Sweden',
                'Switzerland',
                'Syria',
                'Taiwan',
                'Tajikistan',
                'Tanzania',
                'Thailand',
                'Timor-Leste',
                'Tunisia',
                'Turkey',
                'Turkmenistan',
                'Uganda',
                'Ukraine',
                'United Arab Emirates',
                'United Kingdom',
                'United States',
                'Uruguay',
                'Uzbekistan',
                'Venezuela',
                'Vietnam',
                'Yemen',
                'Zimbabwe',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => selectedNegara = v),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Nomor HP *',
              noHpController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 30),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label: label),
    ),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _buildDetailRow(String t1, String v1, String t2, String v2) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t1, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(v1, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t2, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(v2, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ],
  );

  Widget _buildCostRow(
    String label,
    String value, {
    bool isBold = false,
    bool isDiscount = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDiscount ? Colors.green : Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isDiscount ? Colors.green : Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
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
