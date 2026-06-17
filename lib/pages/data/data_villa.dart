// ============================================================
// Data villa
// ============================================================

List<Map<String, dynamic>> promoList = [
  {
    "image": "assets/img/promo1.png",
    "judul": "Diskon Spesial 50%",
    "deskripsi":
        "Nikmati diskon 10% untuk semua villa pilihan selama bulan Juni. Jangan lewatkan kesempatan ini untuk liburan hemat bersama keluarga!",
    "syarat":
        "- Berlaku untuk pemesanan min. 2 malam\n- Tidak dapat digabung dengan promo lain\n- Berlaku s.d 30 Juni 2026",
    "kodePromo": "DISKON10",
  },
  {
    "image": "assets/img/promo2.png",
    "judul": "Weekend Getaway",
    "deskripsi":
        "Pesan villa untuk akhir pekan dan dapatkan potongan harga spesial. Cocok untuk kamu yang butuh rehat dari rutinitas!",
    "syarat":
        "- Berlaku untuk check-in Sabtu & Minggu\n- Min. 1 malam menginap\n- Berlaku s.d 31 Juli 2026",
    "kodePromo": "DISKON10",
  },
  {
    "image": "assets/img/promo3.png",
    "judul": "Weekend Getaway",
    "deskripsi":
        "Pesan villa untuk akhir pekan dan dapatkan potongan harga spesial. Cocok untuk kamu yang butuh rehat dari rutinitas!",
    "syarat":
        "- Berlaku untuk check-in Sabtu & Minggu\n- Min. 1 malam menginap\n- Berlaku s.d 31 Juli 2026",
    "kodePromo": "DISKON10",
  },
];

final List<Map<String, dynamic>> villaList = [
  {
    "id": "v1",
    "ownerId": "owner-01",
    "name": "Villa Rumah HC",
    "city": "Bogor",
    "lokasi": "Kabupaten Bogor",
    "alamat":
        "Rumah HC Jl. Kopo, Kopo, Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16750",
    "rating": 8.3,
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
        "Temukan kembali ketenangan jiwa di tengah pelukan alam yang masih asri. Villa ini dirancang khusus bagi Anda yang ingin melarikan diri sejenak dari hiruk-pikuk dunia dan memulihkan energi dalam suasana yang damai.",
    "image": "assets/img/villa1.jpeg",
  },
  {
    "id": "v2",
    "ownerId": "owner-01",
    "name": "Villa Sunset",
    "city": "Bali",
    "lokasi": "Bali, Indonesia",
    "rating": 8.3,
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
        "Sebuah definisi kemewahan yang tak lekang oleh waktu. Nikmati pengalaman menginap dengan standar pelayanan kelas atas yang memberikan privasi penuh, cocok bagi Anda yang menginginkan momen istimewa bersama orang-orang tercinta.",
    "image": "assets/img/villa2.jpeg",
  },
  {
    "id": "v3",
    "ownerId": "owner-02",
    "name": "Nirvana Villas Puncak",
    "city": "Bogor",
    "lokasi": "Kabupaten Bogor",
    "alamat":
        "Nirvana Villas Puncak Jl.Gandamanah No.29-40, Tugu Sel., Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16750",
    "rating": "8.4",
    "price": "1.500.000",
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
        "Ciptakan kenangan indah yang tak terlupakan di tempat yang dirancang untuk kebersamaan. Setiap sudut villa ini memancarkan kehangatan yang membuat Anda betah berlama-lama dan enggan untuk beranjak.",
    "image": "assets/img/villa3.jpeg",
  },
  {
    "id": "v4",
    "ownerId": "owner-02",
    "name": "Villa Kay Garden",
    "city": "Bogor",
    "lokasi": "Cisarua",
    "alamat":
        "Villa Kay Garden Jl. Bumi Susi No.8, Citeko, Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16770",
    "rating": 8.3,
    "price": "1.800.000",
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
        "Tempat yang memadukan keindahan estetika dengan kenyamanan maksimal untuk hunian liburan Anda. Setiap sudutnya menawarkan pemandangan menakjubkan yang akan memanjakan mata dan menyempurnakan hari-hari libur Anda.",
    "image": "assets/img/villa4.jpeg",
  },
  {
    "id": "v5",
    "ownerId": "owner-02",
    "name": "Palette Resort Argya Santi Jimbaran",
    "city": "Bandung",
    "lokasi": "Jimbaran",
    "alamat":
        "Palette Resort Argya Santi Jimbaran Jl. Jepun I Sakura, Jimbaran, Kec. Kuta Sel., Kabupaten Badung, Bali 80361",
    "rating": 8.3,
    "price": "1.000.000",
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
        "Sebuah rahasia kecil untuk liburan yang luar biasa. Lokasinya yang tersembunyi menjanjikan ketenangan yang jarang ditemukan, memberikan Anda pengalaman menginap yang sangat personal dan jauh dari keramaian.",
    "image": "assets/img/villa5.jpeg",
  },
];

// ============================================================
// DATA BOOKING (Sistem Admin)
// ============================================================
// List ini yang akan diakses/diupdate oleh admin.
// Setiap kali ada booking, masukkan data ke sini.

List<Map<String, dynamic>> bookingList = [
  {
    "bookingId": "VLK464672",
    "villaId": "v1", // Menghubungkan booking ini ke Villa Bogor Uhuy
    "startDate": DateTime(2026, 6, 6),
    "endDate": DateTime(2026, 6, 7),
    "customerName": "Pond Naravit",
    "email": "phuphu@gmail.com",
    "no_hp": "0875789755",
  },
  {
    "bookingId": "VLK464682",
    "villaId": "v2", // Menghubungkan booking ini ke Villa Bogor Uhuy
    "startDate": DateTime(2026, 6, 13),
    "endDate": DateTime(2026, 6, 14),
    "customerName": "John",
    "email": "phuphu@gmail.com",
    "no_hp": "087579775",
  },
];

List<Map<String, dynamic>> ulasanList = [
  {
    "villaId": "v1",
    "nama": "Budi",
    "bintang": 5,
    "komentar": "Tempatnya bagus dan bersih!",
    "tanggal": "10 Jun 2026",
  },
  {
    "villaId": "v1",
    "nama": "Sari",
    "bintang": 4,
    "komentar": "Nyaman, pelayanan ramah.",
    "tanggal": "12 Jun 2026",
  },
  {
    "villaId": "v2",
    "nama": "Budi",
    "bintang": 5,
    "komentar": "Tempatnya bagus dan bersih!",
    "tanggal": "10 Jun 2026",
  },
  {
    "villaId": "v3",
    "nama": "Nining",
    "bintang": 4,
    "komentar": "Nyaman banget",
    "tanggal": "12 Jun 2026",
  },
  {
    "villaId": "v4",
    "nama": "gemini",
    "bintang": 5,
    "komentar": "indah sekali",
    "tanggal": "10 Jun 2026",
  },
  {
    "villaId": "v5",
    "nama": "cima",
    "bintang": 5,
    "komentar": "pelayanan ramah.",
    "tanggal": "12 Jun 2026",
  },
];

final List<String> kotaList = ["Bogor", "Bandung", "Bali", "Jakarta"];

final List<String> searchVillaList = villaList
    .map((v) => v["name"] as String)
    .toList();
