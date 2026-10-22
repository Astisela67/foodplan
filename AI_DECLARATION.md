# Deklarasi Penggunaan AI (AI Declaration)

**Nama:** Asti Sela  
**NPM:** 2413025067  
**Kelas:** PTI24A  
**Proyek:** FoodPlan (Mobile Programming)

## 1. Daftar Alat AI

### ChatGPT

Digunakan untuk membantu memahami dan menganalisis kesalahan kode Flutter, mencari alternatif perbaikan logika, menjelaskan fungsi kode, serta membantu menyusun dan merapikan dokumentasi proyek.

**Alat non-AI yang digunakan:**
- Flutter SDK untuk menjalankan dan membangun aplikasi.
- Visual Studio Code untuk menulis dan mengedit kode.
- Android Studio untuk mendukung pengembangan dan pengujian aplikasi Android.
- `flutter analyze` untuk membantu memeriksa masalah pada kode.
- Git dan GitHub untuk mengelola riwayat perubahan dan menyimpan repositori proyek.

## 2. Pembagian Peran

### 2.1 Rancangan PRD, SRD, Diagram, dan Wireframe

**Peran: Campuran**

ChatGPT membantu menyusun dan merapikan dokumentasi serta memberikan saran struktur. Isi akhir disesuaikan dengan kebutuhan proyek dan implementasi aplikasi FoodPlan.

### 2.2 Struktur Folder dan `main.dart`

**Peran: Campuran**

Pengembangan menggunakan Flutter dan Provider. Bantuan AI digunakan untuk memahami struktur kode dan mencari alternatif solusi, sedangkan kode diperiksa serta disesuaikan dengan kebutuhan proyek.

### 2.3 Halaman Splash, Login, dan Register

**Peran: Campuran**

Berkas tersebut merupakan bagian dari pengembangan versi sebelumnya. Validasi dan kesalahan pada versi awal menjadi bahan evaluasi. Pada implementasi terbaru, alur Login dan Register tidak lagi digunakan sebagai alur utama aplikasi.

### 2.4 `main_shell.dart`

**Peran: Campuran**

File ini digunakan untuk mengatur struktur navigasi dan perpindahan halaman. Pengembangan dan penyesuaiannya dilakukan berdasarkan kebutuhan antarmuka aplikasi.

### 2.5 `model/recipe.dart`

**Peran: Campuran**

File ini memuat model dan data resep, termasuk informasi bahan, langkah memasak, serta nutrisi. Bantuan AI digunakan untuk memahami struktur model, sedangkan data dan implementasinya disesuaikan dengan kebutuhan FoodPlan.

### 2.6 `state/app_state.dart`

**Peran: Campuran**

File ini mengelola state aplikasi, termasuk rencana menu, daftar belanja, profil, dan penyimpanan data lokal. Bantuan AI digunakan untuk menganalisis kemungkinan masalah, sedangkan penerapan dan penyesuaian kode dilakukan berdasarkan kebutuhan aplikasi.

### 2.7 Daftar Belanja Otomatis

**Peran: Campuran**

Bagian ini mencakup penggabungan bahan, pengelolaan `shoppingItems`, status bahan yang sudah dicentang, dan proses checkout. Logikanya diperiksa agar bahan dari beberapa resep dapat dikelola secara konsisten.

### 2.8 Halaman Resep, Detail Resep, dan `add_to_plan_sheet.dart`

**Peran: Campuran**

Halaman dan komponen ini mendukung tampilan informasi resep serta penambahan resep ke rencana menu. Struktur dan fungsinya disesuaikan dengan kebutuhan aplikasi.

### 2.9 Halaman Profil, Pengaturan, Target, Riwayat, dan Bantuan

**Peran: Campuran**

Pengembangan bagian ini mengikuti kebutuhan fitur FoodPlan. Bantuan AI digunakan untuk memahami kode dan mencari alternatif perbaikan jika ditemukan masalah.

### 2.10 Penambahan Foto Resep

**Peran: Campuran**

Penambahan gambar resep dan komponen seperti `recipe_image.dart` serta `MealSlotCard` mendukung tampilan resep agar lebih mudah dikenali pengguna.

### 2.11 Debugging dan Pengujian

**Peran: Campuran**

ChatGPT digunakan untuk membantu menganalisis pesan kesalahan dan memberikan alternatif solusi. Pemeriksaan kode, penyesuaian implementasi, dan pengujian dilakukan pada proyek secara langsung.

**Logika yang saya pelajari dan periksa:** pengelolaan rencana menu, penggabungan bahan pada daftar belanja, status bahan yang sudah dicentang, dan penyimpanan data lokal.

**Bagian yang dibantu AI:** analisis kesalahan, penjelasan kode, saran perbaikan logika, serta penyusunan dokumentasi. Saran AI perlu diperiksa kesesuaiannya dengan kebutuhan dan kode proyek sebelum diterapkan.

## 3. Studi Kasus Prompting

### Studi Kasus 1: Penyelarasan Nama File dan Import (Minggu 2)

**Prompt:**

> Buatkan 9 halaman Flutter sesuai SRD dengan struktur folder `lib/screen` dan `lib/widget`.

**Hasil awal AI:**

AI menghasilkan kode untuk halaman aplikasi, tetapi program belum dapat dikompilasi karena terdapat ketidaksesuaian nama file dan jalur import. Contohnya, `shopping_list.dart` dengan `shopping_list_screen.dart`, serta `shopping_item__tile.dart` dengan `shopping_item_tile.dart`. Selain itu, file `setting_tile.dart` berisi duplikasi komponen `WeekCalendarStrip` yang tidak sesuai dengan fungsi file tersebut.

**Penyesuaian manual:**

Saya mencocokkan nama file dengan jalur import yang digunakan. Saya juga mengganti isi file yang salah dengan komponen yang benar, kemudian menjalankan `flutter analyze` untuk memeriksa kesalahan kode.

**Hasil:**

Kesalahan import berhasil diatasi dan program dapat dikompilasi setelah penyesuaian dilakukan.

### Studi Kasus 2: Perbaikan Status "Sudah Dibeli" pada Daftar Belanja

**Prompt:**

> Buatkan halaman Daftar Belanja dengan checkbox dan filter Semua, Belum Dibeli, dan Sudah Dibeli.

**Hasil awal AI:**

Pada implementasi awal, status pembelian dicari menggunakan `firstWhere` berdasarkan nama bahan. Cara ini berpotensi menyebabkan item yang salah tercentang apabila terdapat dua bahan dengan nama yang sama.

**Penyesuaian manual:**

Saya mengubah rancangan identifikasi item menggunakan kunci unik untuk setiap bahan. Bahan otomatis menggunakan kunci gabungan `nama|satuan`, sedangkan bahan yang ditambahkan secara manual menggunakan ID unik. Status pembelian kemudian dikaitkan dengan kunci tersebut agar setiap item memiliki identitas yang berbeda.

**Hasil:**

Status centang dapat dikaitkan dengan item yang sesuai sehingga risiko salah centang dapat dihindari. Selain itu, bahan yang sama dari beberapa resep dapat digabungkan menjadi satu baris sesuai identitas bahan dan satuannya.