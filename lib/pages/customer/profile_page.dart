import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notifPush = true;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String nama = user?['nama'] ?? 'Pengguna';
    final String email = user?['email'] ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xffF3F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F5F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Foto & Nama ──
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      nama.isNotEmpty ? nama[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff003B73),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── Manajemen Akun ──
            _sectionLabel('Manajemen Akun'),
            _menuCard([
              _menuItem(
                icon: Icons.person_outline,
                label: 'Informasi Pribadi',
                onTap: () {},
              ),
              _divider(),
              _menuItem(
                icon: Icons.receipt_long_outlined,
                label: 'Pesanan Saya',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 20),

            // ── Preferensi ──
            _sectionLabel('Preferensi'),
            _menuCard([
              _switchItem(
                icon: Icons.notifications_outlined,
                label: 'Notifikasi Push',
                value: notifPush,
                onChanged: (v) => setState(() => notifPush = v),
              ),
            ]),

            const SizedBox(height: 20),

            // ── Dukungan ──
            _sectionLabel('Dukungan'),
            _menuCard([
              _menuItem(
                icon: Icons.help_outline,
                label: 'Bantuan & Dukungan',
                onTap: () {},
              ),
              _divider(),
              _menuItem(
                icon: Icons.security_outlined,
                label: 'Keamanan & Kata Sandi',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 28),

            // ── Tombol Keluar ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => _konfirmasiLogout(context),
                icon: const Icon(Icons.logout, color: Color(0xff003B73)),
                label: const Text(
                  'Keluar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff003B73),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff003B73)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Apakah kamu yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              AuthService.logout();
              Navigator.pop(ctx);
              Navigator.pop(context); // kembali ke beranda
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff003B73),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _menuCard(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(children: children),
  );

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) => ListTile(
    onTap: onTap,
    leading: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xffF0F4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: const Color(0xff003B73), size: 20),
    ),
    title: Text(label, style: const TextStyle(fontSize: 15)),
    trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
  );

  Widget _switchItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => ListTile(
    leading: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xffF0F4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: const Color(0xff003B73), size: 20),
    ),
    title: Text(label, style: const TextStyle(fontSize: 15)),
    trailing: Switch(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xff003B73),
    ),
  );

  Widget _divider() => Divider(
    height: 1,
    indent: 68,
    endIndent: 16,
    color: Colors.grey.shade100,
  );
}
