// data_user.dart

// ====================================================================
// 1. KELOMPOK DATA KHUSUS CUSTOMER (PELANGGAN / PENYEWA VILLA)
// ====================================================================
final List<Map<String, String>> daftarCustomer = [
  {
    'id_user': 'CUST-001',
    'email': 'user@gmail.com',
    'password': '123456',
    'role': 'customer',
    'nama_lengkap': 'Pond Naravit',
    'no_hp': '081234567890',
    'nik': '3275012345670001',
    'kota_asal': 'Bekasi',
    'foto_profil': 'assets/images/profiles/budi.png',
  },
  {
    'id_user': 'CUST-002',
    'email': 'userbaru@gmail.com',
    'password': '654321',
    'role': 'customer',
    'nama_lengkap': 'phuwing',
    'no_hp': '085711223344',
    'nik': '3275098765430002',
    'foto_profil': 'assets/images/profiles/siti.png',
  },
];

// ====================================================================
// 2. KELOMPOK DATA KHUSUS ADMIN (PEMILIK / PENGELOLA VILLA)
// ====================================================================
final List<Map<String, String>> daftarOwner = [
  {
    'ownerId': 'owner-01',
    'email': 'owner1@gmail.com',
    'password': 'admin123',
    'role': 'admin',
    'nama_lengkap': 'Hendra Wijaya',
    'no_hp': '089988776655',
    'kota_asal': 'Bogor',
    'pendapatan': '1.2 M',
    'foto_profil': 'assets/images/profiles/admin_hendra.png',
  },
  {
    'ownerId': 'owner-02',
    'email': 'owner2@gmail.com',
    'password': 'admin123',
    'role': 'admin',
    'nama_lengkap': 'Hendra Wijaya',
    'no_hp': '089988776655',
    'kota_asal': 'Bogor',
    'pendapatan': '1.2 M',
    'foto_profil': 'assets/images/profiles/admin_hendra.png',
  },
];
