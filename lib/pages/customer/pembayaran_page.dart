import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sukses_page.dart';

class PembayaranPage extends StatefulWidget {
  final int total;
  final Map villa;
  final String tanggal;

  const PembayaranPage({
    super.key,
    required this.total,
    required this.villa,
    required this.tanggal,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  String? selectedMetode; // 'transfer' | 'va' | 'ewallet'
  String? selectedBank;
  bool isLoading = false;

  final Map<String, Map<String, String>> _bankInfo = {
    'BCA': {'norek': '1234567890', 'atas_nama': 'PT Villaku Indonesia'},
    'Mandiri': {'norek': '9876543210', 'atas_nama': 'PT Villaku Indonesia'},
    'BNI': {'norek': '1122334455', 'atas_nama': 'PT Villaku Indonesia'},
  };

  final Map<String, Map<String, String>> _vaInfo = {
    'BCA Virtual Account': {'kode': '70012', 'va': '7001212345678901'},
    'Mandiri Virtual Account': {'kode': '89888', 'va': '8988812345678901'},
    'BRI Virtual Account': {'kode': '15702', 'va': '1570212345678901'},
  };

  final Map<String, String> _ewalletInfo = {
    'GoPay': '0812-3456-7890',
    'OVO': '0812-3456-7890',
    'DANA': '0812-3456-7890',
  };

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text disalin'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _prosesBayar() async {
    if (selectedMetode == null || selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih metode pembayaran terlebih dahulu'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulasi proses
    if (!mounted) return;
    setState(() => isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => SuksesPage(
          villa: widget.villa,
          tanggal: widget.tanggal,
          total: widget.total,
          metodeBayar: selectedBank!,
        ),
      ),
      (route) => route.isFirst, // kembali ke beranda kalau back
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Total tagihan ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff003B73),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatRupiah(widget.total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.villa['name'],
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ── Transfer Bank ──
            _MetodeSection(
              title: 'Transfer Bank',
              icon: Icons.account_balance,
              isSelected: selectedMetode == 'transfer',
              onTap: () => setState(() {
                selectedMetode = 'transfer';
                selectedBank = null;
              }),
              child: selectedMetode == 'transfer'
                  ? Column(
                      children: _bankInfo.entries.map((e) {
                        final isActive = selectedBank == e.key;
                        return GestureDetector(
                          onTap: () => setState(() => selectedBank = e.key),
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xffE8F0FE)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? const Color(0xff003B73)
                                    : Colors.grey.shade200,
                                width: isActive ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (isActive)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xff003B73),
                                        size: 20,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'No. Rekening',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      e.value['norek']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          _copyToClipboard(e.value['norek']!),
                                      child: const Icon(
                                        Icons.copy,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'a/n ${e.value['atas_nama']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : null,
            ),

            const SizedBox(height: 12),

            // ── Virtual Account ──
            _MetodeSection(
              title: 'Virtual Account',
              icon: Icons.credit_card,
              isSelected: selectedMetode == 'va',
              onTap: () => setState(() {
                selectedMetode = 'va';
                selectedBank = null;
              }),
              child: selectedMetode == 'va'
                  ? Column(
                      children: _vaInfo.entries.map((e) {
                        final isActive = selectedBank == e.key;
                        return GestureDetector(
                          onTap: () => setState(() => selectedBank = e.key),
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xffE8F0FE)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? const Color(0xff003B73)
                                    : Colors.grey.shade200,
                                width: isActive ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (isActive)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xff003B73),
                                        size: 20,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Nomor VA',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      e.value['va']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          _copyToClipboard(e.value['va']!),
                                      child: const Icon(
                                        Icons.copy,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : null,
            ),

            const SizedBox(height: 12),

            // ── E-Wallet ──
            _MetodeSection(
              title: 'E-Wallet / QRIS',
              icon: Icons.qr_code,
              isSelected: selectedMetode == 'ewallet',
              onTap: () => setState(() {
                selectedMetode = 'ewallet';
                selectedBank = null;
              }),
              child: selectedMetode == 'ewallet'
                  ? Column(
                      children: _ewalletInfo.entries.map((e) {
                        final isActive = selectedBank == e.key;
                        return GestureDetector(
                          onTap: () => setState(() => selectedBank = e.key),
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xffE8F0FE)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? const Color(0xff003B73)
                                    : Colors.grey.shade200,
                                width: isActive ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          e.value,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () =>
                                              _copyToClipboard(e.value),
                                          child: const Icon(
                                            Icons.copy,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (isActive)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xff003B73),
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : null,
            ),

            const SizedBox(height: 32),

            // ── Tombol Bayar ──
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _prosesBayar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff003B73),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Bayar ${_formatRupiah(widget.total)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ── Widget section metode ─────────────────────────────────────
class _MetodeSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? child;

  const _MetodeSection({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xff003B73) : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xffE8F0FE)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xff003B73) : Colors.grey,
                size: 22,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xff003B73) : Colors.black87,
              ),
            ),
            trailing: Icon(
              isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ),
          if (child != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child!,
            ),
        ],
      ),
    );
  }
}
