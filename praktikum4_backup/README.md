# Tugas Asistensi Praktikum Modul 4: Implementasi Backup

## Catatan
> Praktikan dilarang menggunakan database atau tabel dari modul sebelumnya. Data harus dihasilkan dari script yang disediakan dalam repositori ini.

**Kerjakan tugas ini secara individu. Dimohon tidak hanya mengerjakan tugas ini, tetapi juga memahami apa yang kalian kerjakan!**
- Tugas dikerjakan menggunakan database `national_weather` yang terbentuk setelah `bash import_data.sh`.
- Tugas dikerjakan dengan LaTeX dan dikumpulkan dalam format PDF.
- Sertakan **screenshot atau hasil `EXPLAIN ANALYZE` atau log terminal** dari percobaan partitioning.
- Gunakan bahasa Indonesia yang baik dan benar.
---
- **Yang perlu dikumpulkan adalah:**
  1. Tugas Asistensi (PDF)
  2. Laporan Lengkap (PDF)
- Pengumpulan di Google Drive - [Pengumpulan Praktikum 4 (klik di sini)](https://drive.google.com/drive/folders/1t5gX7oyCYwENG2ldK4yhuoNjGXWtC74F?usp=sharing) sesuai folder nama masing-masing yang telah disediakan, dengan format nama file khusus untuk file tugas adalah `TugasAsistensi4_(NoKelompok)_(NRP)_(Nama Lengkap).pdf`.
  > (Contoh: `TugasAsistensi4_10_5024221058_Rigel Ramadhani Waloni.pdf`)
- Untuk Laporan Lengkap, kalian langsung kumpulkan di Google Drive yang sama (di atas), tidak perlu buat Google Drive sendiri.
- **Tugas Asistensi + Laporan Full/Lengkap adalah sebelum agenda Asistensi pada tanggal `15 Juni 2025 pukul 09.00 WIB`.**
---

## Setup Awal (Database Baru, Tabel, dan Import Data CSV)
1. Silahkan clone repositori ini ke dalam folder lokal.
2. Pastikan Docker sudah terinstall dan container yang digunakan saat praktikum sebelumnya sudah berjalan.
3. Buka terminal dan cd ke folder `praktikum4_backup > scripts` di repositori ini (sudah di-clone).
4. Jalankan perintah berikut untuk mengimpor data CSV yang sudah ada di folder `data` **(tidak perlu generate data lagi)** ke database :
```bash
bash import_data.sh
```
5. Tunggu hingga proses selesai. Setelah itu, Anda dapat memeriksa data dengan membuka PGAdmin dengan langkah-langkah pada repo praktikum.

6. Terdapat 1 tabel yang sudah di-import ke dalam database `national_weather`:
    - `weather_data`: berisi data cuaca fiktif yang akan digunakan untuk eksperimen backup dan recovery.

7. Data sudah siap digunakan untuk tugas ini.

<br>

## Soal Tugas Asistensi - Backup and Recovery

**Tujuan:**
Menguji pemahaman praktikan tentang konsep backup & recovery di PostgreSQL.

### **Tugas Utama:**
1. Lakukan 3 jenis backup berbeda berikut:
    - Full backup database (pg_dump)
    - Backup hanya struktur (--schema-only)
    - Backup hanya tabel `weather_data` (-t weather_data)
2. Lakukan simulasi skenario kehilangan data:
    - Hapus tabel `weather_data`.
    - Lakukan restore dari salah satu backup yang Anda lakukan.
3. Buat script otomatis backup:
    - Backup disimpan dalam folder `backup/` dengan format nama: `backup_full_<timestamp>.sql`.
    - Otomatis menghapus backup lebih dari 3 hari.
4. Buat laporan yang menjawab pertanyaan berikut:
    - Apa kelebihan/kekurangan backup logical dibanding physical?
    - Mengapa penting menyimpan backup dalam format custom (.dump)?
    - Bagaimana Anda merancang strategi backup jika sistem ini dijalankan harian dengan 50.000+ baris data baru?

### **Sertakan:**
1. Hasil log/script backup dan restore.
2. Screenshot terminal atau hasil restore.
3. Penjelasan dalam bentuk PDF.
4. Daftar lengkap perintah backup/restore yang digunakan.