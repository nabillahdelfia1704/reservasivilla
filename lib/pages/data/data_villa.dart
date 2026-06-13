// ============================================================
// SATU-SATUNYA sumber data untuk seluruh aplikasi villa
// Semua page cukup import file ini
// ============================================================

final List<String> promoList = [
  'assets/img/promo1.jpeg',
  'assets/img/promo1.jpeg',
  'assets/img/promo1.jpeg',
];

final List<Map<String, dynamic>> villaList = [
  {
    "id": "v1",
    "ownerId": "owner-01",
    "name": "Villa Rumah HC",
    "city": "Bogor",
    "location": "Kabupaten Bogor",
    "alamat":
        "Rumah HC Jl. Kopo, Kopo, Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16750",
    "rating": "8.3",
    "price": "1.000.000",
    "guests": 8,
    "bedroom": 2,
    "bathroom": 1,
    "wifi": true,
    "ac": true,
    "pool": true,
    "parkir": true,
    "bakMandi": true,
    "dapur": true,
    "description":
        "Villa mewah dengan pemandangan indah, fasilitas lengkap, kolam renang pribadi dan cocok untuk liburan keluarga. Nikmati suasana tenang dengan fasilitas premium.",
    "image": "assets/img/promo2.jpeg",
  },
  {
    "id": "v2",
    "ownerId": "owner-01",
    "name": "Villa Sunset",
    "city": "Bali",
    "location": "Bali, Indonesia",
    "rating": "8.3",
    "price": "1.000.000",
    "guests": 4,
    "bedroom": 2,
    "bathroom": 2,
    "wifi": true,
    "ac": true,
    "pool": false,
    "parkir": true,
    "bakMandi": false,
    "dapur": true,
    "description":
        "Villa modern dengan nuansa tropis khas Bali. Cocok untuk pasangan atau keluarga kecil yang ingin menikmati suasana pulau dewata.",
    "image": "assets/img/promo1.jpeg",
  },
  {
    "id": "v3",
    "ownerId": "owner-02",
    "name": "Nirvana Villas Puncak",
    "city": "Bogor",
    "location": "Kabupaten Bogor",
    "alamat":
        "Nirvana Villas Puncak Jl.Gandamanah No.29-40, Tugu Sel., Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16750",
    "rating": "8.4",
    "price": "2.500.000",
    "guests": 10,
    "bedroom": 5,
    "bathroom": 3,
    "wifi": true,
    "ac": false,
    "pool": true,
    "parkir": true,
    "bakMandi": true,
    "dapur": true,
    "description":
        "Villa mewah dengan pemandangan indah, fasilitas lengkap, kolam renang pribadi dan cocok untuk liburan keluarga. Nikmati suasana tenang dengan fasilitas premium.",
    "image": "assets/img/promo2.jpeg",
  },
  {
    "id": "v4",
    "ownerId": "owner-02",
    "name": "Villa Kay Garden",
    "city": "Bogor",
    "location": "Cisarua",
    "alamat":
        "Villa Kay Garden Jl. Bumi Susi No.8, Citeko, Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16770",
    "rating": "8.3",
    "price": "3.000.000",
    "guests": 15,
    "bedroom": 3,
    "bathroom": 4,
    "wifi": true,
    "ac": true,
    "pool": true,
    "parkir": true,
    "bakMandi": true,
    "dapur": true,
    "description":
        "Villa mewah dengan pemandangan indah, fasilitas lengkap, kolam renang pribadi dan cocok untuk liburan keluarga. Nikmati suasana tenang dengan fasilitas premium.",
    "image": "assets/img/promo2.jpeg",
  },
  {
    "id": "v5",
    "ownerId": "owner-02",
    "name": "Palette Resort Argya Santi Jimbaran",
    "city": "Bandung",
    "location": "Jimbaran",
    "alamat":
        "Palette Resort Argya Santi Jimbaran Jl. Jepun I Sakura, Jimbaran, Kec. Kuta Sel., Kabupaten Badung, Bali 80361",
    "rating": "8.3",
    "price": "600.000",
    "guests": 2,
    "bedroom": 1,
    "bathroom": 1,
    "wifi": false,
    "ac": true,
    "pool": false,
    "parkir": true,
    "bakMandi": true,
    "dapur": true,
    "description":
        "Villa mewah dengan pemandangan indah, fasilitas lengkap, kolam renang pribadi dan cocok untuk liburan keluarga. Nikmati suasana tenang dengan fasilitas premium.",
    "image": "assets/img/promo2.jpeg",
  },
];

// ============================================================
// DATA BOOKING (Sistem Admin)
// ============================================================
// List ini yang akan diakses/diupdate oleh admin.
// Setiap kali ada booking, masukkan data ke sini.

List<Map<String, dynamic>> bookingList = [
  {
    "bookingId": "b1",
    "villaId": "v1", // Menghubungkan booking ini ke Villa Bogor Uhuy
    "startDate": DateTime(2026, 6, 12),
    "endDate": DateTime(2026, 6, 15),
    "customerName": "John Doe",
  },
  {
    "bookingId": "b2",
    "villaId": "v2", // Menghubungkan booking ini ke Villa Bogor Uhuy
    "startDate": DateTime(2026, 6, 12),
    "endDate": DateTime(2026, 6, 15),
    "customerName": "John",
  },
];

final List<String> kotaList = ["Bogor", "Bandung", "Bali", "Jakarta"];

final List<String> searchVillaList = villaList
    .map((v) => v["name"] as String)
    .toList();
