# Tugas Asistensi Praktikum Modul 3: Implementasi Partitioning

## Catatan
> Praktikan diharapkan **tidak menggunakan tabel orders/products dari praktikum sebelumnya**, karena kasus ini berbeda dan bersifat mandiri.

**Kerjakan tugas ini secara individu. Dimohon tidak hanya mengerjakan tugas ini, tetapi juga memahami apa yang kalian kerjakan!**
- Tugas dikerjakan menggunakan database `national_weather` yang terbentuk setelah `bash import_data.sh`.
- Tugas dikerjakan dengan LaTeX dan dikumpulkan dalam format PDF.
- Sertakan **screenshot atau hasil `EXPLAIN ANALYZE` atau log terminal** dari percobaan partitioning.
- Gunakan bahasa Indonesia yang baik dan benar.
---
- **Yang perlu dikumpulkan adalah:**
  1. Tugas Asistensi (PDF)
  2. Laporan Lengkap (PDF)
- Pengumpulan di Google Drive - [Pengumpulan Praktikum 3 (klik di sini)](https://drive.google.com/drive/folders/1p5Ubm8IvXgZjFadb2e1vjAUHInW2bjfV?usp=sharing) sesuai folder nama masing-masing yang telah disediakan, dengan format nama file khusus untuk file tugas adalah `TugasAsistensi3_(NoKelompok)_(NRP)_(Nama Lengkap).pdf`.
  > (Contoh: `TugasAsistensi3_10_5024221058_Rigel Ramadhani Waloni.pdf`)
- Untuk Laporan Lengkap, kalian langsung kumpulkan di Google Drive yang sama (di atas), tidak perlu buat Google Drive sendiri.
- **Tugas Asistensi + Laporan Full/Lengkap adalah sebelum agenda Asistensi pada tanggal `1 Juni 2025 pukul 19.00 WIB`.**
---

## Setup Awal (Database Baru, Tabel, dan Import Data CSV)
1. Silahkan clone repositori ini ke dalam folder lokal.
2. Pastikan Docker sudah terinstall dan container yang digunakan saat praktikum sebelumnya sudah berjalan.
3. Buka terminal dan cd ke folder `praktikum3_transaction > scripts` di repositori ini (sudah di-clone).
4. Jalankan perintah berikut untuk mengimpor data CSV yang sudah ada di folder `data` **(tidak perlu generate data lagi)** ke database :
```bash
bash import_data.sh
```
5. Tunggu hingga proses selesai. Setelah itu, Anda dapat memeriksa data dengan membuka PGAdmin dengan langkah-langkah pada repo praktikum.

6. Terdapat 1 tabel yang sudah di-import ke dalam database `national_weather`:
    - `weather_data`: menyimpan data cuaca harian dari berbagai lokasi di seluruh dunia.

7. Data sudah siap digunakan untuk tugas ini.

<br>

## Soal Tugas Asistensi - Partitioning

## Hal yang Harus Dikumpulkan
1. Screenshot dari hasil `EXPLAIN ANALYZE` (tabel asli vs tabel partisi).
2. Penjelasan singkat dalam 1-2 paragraf:
    - Apakah partisi membuat query lebih efisien? Mengapa?
    - Apa tantangan dalam implementasi partisi berdasarkan data cuaca?
    - Jika sistem ini diperluas nasional selama 10 tahun, strategi partisi seperti apa yang akan Anda sarankan?
3. **Daftar semua script SQL yang digunakan**, disusun sebagai satu section khusus (tetap dalam bagian Tugas Asistensi).
> 💡 Gunakan penomoran langkah dan komentar SQL agar daftar script mudah dibaca!


### **Tugas Utama:**
1. Buatlah partisi pada tabel `weather_data` menggunakan salah satu teknik berikut:
    - **Range Partitioning** berdasarkan `reading_time`, atau
    - **List Partitioning** berdasarkan `province`.
2. Buat minimal 4 partisi.
3. Salin data dari tabel asli ke tabel hasil partisi.
4. Jalankan query berikut dan bandingkan performa sebelum dan sesudah partisi:
```sql
SELECT AVG(temperature)
FROM weather_data
WHERE reading_time BETWEEN '2024-12-01' AND '2024-12-31';
```
atau (jika memakai List Partitioning):
```sql
SELECT AVG(temperature)
FROM weather_data
WHERE province = 'Jawa Timur';
```
5. Gunakan `EXPLAIN ANALYZE` untuk melihat perbedaan performa query sebelum dan sesudah partisi dan jelaskan hasilnya dalam laporan Anda.