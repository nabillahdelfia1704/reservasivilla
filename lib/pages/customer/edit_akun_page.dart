import 'package:flutter/material.dart';
import '../auth/customer/auth_service.dart';

class EditAkunPage extends StatefulWidget {
  const EditAkunPage({super.key});

  @override
  State<EditAkunPage> createState() => _EditAkunPageState();
}

class _EditAkunPageState extends State<EditAkunPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _hpController;
  late TextEditingController _kotaController;

  String _fotoProfil = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;

    _namaController = TextEditingController(
      text: (user?['nama_lengkap'] ?? '').toString(),
    );
    _emailController = TextEditingController(
      text: (user?['email'] ?? '').toString(),
    );
    _hpController = TextEditingController(
      text: (user?['no_hp'] ?? '').toString(),
    );
    _kotaController = TextEditingController(
      text: (user?['kota_asal'] ?? '').toString(),
    );
    _fotoProfil = (user?['foto_profil'] ?? '').toString();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _kotaController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    AuthService.currentUser?['nama_lengkap'] = _namaController.text.trim();
    AuthService.currentUser?['email'] = _emailController.text.trim();
    AuthService.currentUser?['no_hp'] = _hpController.text.trim();
    AuthService.currentUser?['kota_asal'] = _kotaController.text.trim();

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profil berhasil diperbarui'),
        backgroundColor: const Color(0xff003B73),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final String inisial = _namaController.text.isNotEmpty
        ? _namaController.text[0].toUpperCase()
        : 'P';

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff003B73),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Akun',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar / Foto Profil ──
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _fotoProfil.isNotEmpty
                          ? AssetImage(_fotoProfil)
                          : null,
                      onBackgroundImageError: _fotoProfil.isNotEmpty
                          ? (_, _) {}
                          : null,
                      child: _fotoProfil.isEmpty
                          ? Text(
                              inisial,
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff003B73),
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xff003B73),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _sectionLabel('Informasi Akun'),
              const SizedBox(height: 14),

              _buildField(
                controller: _namaController,
                label: 'Nama Lengkap',
                icon: Icons.person_outline,
                hint: 'Masukkan nama lengkap',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                hint: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _hpController,
                label: 'No. HP',
                icon: Icons.phone_outlined,
                hint: 'Masukkan no. HP',
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'No. HP tidak boleh kosong'
                    : null,
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _kotaController,
                label: 'Kota Asal',
                icon: Icons.location_city_outlined,
                hint: 'Masukkan kota asal',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Kota asal tidak boleh kosong'
                    : null,
              ),

              const SizedBox(height: 36),

              // ── Tombol Simpan ──
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff003B73),
                    disabledBackgroundColor: const Color(
                      0xff003B73,
                    ).withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
      letterSpacing: 0.3,
    ),
  );

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xff003B73), size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xff003B73),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
