# Tugas Asistensi Praktikum Modul 2: Transaksi dan Konkurensi

## Catatan
**Kerjakan tugas ini secara individu. Dimohon tidak hanya mengerjakan tugas ini, tetapi juga memahami apa yang kalian kerjakan!**
- Tugas dikerjakan menggunakan database `library` yang Anda buat melalui `import_data.sh`.
- Tugas dikerjakan dengan LaTeX dan dikumpulkan dalam format PDF.
- Sertakan **screenshot atau hasil `EXPLAIN ANALYZE`, `ROLLBACK`, `COMMIT`, atau log terminal** dari percobaan transaksi.
- Gunakan bahasa Indonesia yang baik dan benar.
---
- **Yang perlu dikumpulkan adalah:**
  1. Tugas Asistensi (PDF)
  2. Laporan Lengkap (PDF)
  3. SQL Script (SQL) yang sudah kalian buat
- Kirimkan secara terpisah di Google Drive - [Pengumpulan Praktikum 2 (klik di sini)](https://drive.google.com/drive/folders/15u4Nlqzs5x8a8fuIZiGaFopOHhl46ZP5?usp=sharing) sesuai folder nama masing-masing yang telah disediakan, dengan format nama file khusus untuk file tugas adalah `TugasAsistensi_2_NRP_Nama Lengkap.pdf`.
  > (Contoh: `TugasAsistensi_2_5024221058_Rigel Ramadhani Waloni.pdf`)
- Untuk Laporan Lengkap, kalian langsung kumpulkan di Google Drive yang sama (di atas), tidak perlu buat Google Drive sendiri, aku sediakan saja.
- **Batas pengumpulan SQL Script + Tugas Asistensi + Laporan Full/Lengkap adalah sebelum agenda Asistensi pada tanggal `25 Mei 2025 pukul 09.00 WIB`.**
---

## Setup Awal (Database Baru, Tabel, dan Import Data CSV)
1. Silahkan clone repositori ini ke dalam folder lokal.
2. Pastikan Docker sudah terinstall dan container yang digunakan saat praktikum sebelumnya sudah berjalan.
3. Buka terminal dan cd ke folder `praktikum2_transaction > scripts` di repositori ini (sudah di-clone).
4. Jalankan perintah berikut untuk mengimpor data CSV yang sudah ada di folder `data` **(tidak perlu generate data lagi)** ke database :
```bash
bash import_data.sh
```
5. Tunggu hingga proses selesai. Setelah itu, Anda dapat memeriksa data dengan membuka PGAdmin dengan langkah-langkah pada repo praktikum.

6. Terdapat 3 tabel yang sudah di-import ke dalam database `library`:
   - `books`: menyimpan data buku dan stok
   - `members`: menyimpan data anggota perpustakaan
   - `borrowings`: riwayat peminjaman buku

7. Data sudah siap digunakan untuk tugas ini.

<br>

## Soal Tugas Asistensi - Transaksi dan Konkurensi

## Hal yang Harus Dikumpulkan
1. Script SQL transaksi peminjaman buku (dengan `BEGIN`, `COMMIT`, `ROLLBACK`).

2. Hasil tangkapan layar dari:

    - Transaksi sukses dan gagal

    - `REPEATABLE READ` vs `READ COMMITTED`

    - Log konkurensi dari dua terminal

3. Penjelasan mengenai bagaimana implementasimu memenuhi prinsip **ACID**.

4. Analisis singkat:

    - Apa yang terjadi jika tidak menggunakan transaksi?

    - Apa efek jika tidak menggunakan `REPEATABLE READ`?

    - Apakah ada potensi **dirty read**, **non-repeatable read**, atau **phantom read**?

### **Tugas Utama:**
Buatlah skenario transaksi peminjaman buku yang memenuhi kriteria berikut:
1. Cek apakah stok buku masih tersedia.
2. Jika tersedia:
    - Kurangi stok buku di tabel books.
    - Catat peminjaman di tabel borrowings.
    - Gunakan tingkat isolasi transaksi REPEATABLE READ.
3. Jika stok tidak mencukupi, transaksi dibatalkan (ROLLBACK).
4. Transaksi harus **ACID-compliant**:
    - Tunjukkan atomicity, consistency, isolation, dan durability.
5. Tunjukkan juga bagaimana skenario ini mencegah non-repeatable read.
6. **_(Opsional)_** Tambahkan tabel `borrowing_items` jika ingin mendukung peminjaman >1 buku.

## Eksperimen Konkurensi

Lakukan simulasi **dua transaksi bersamaan** dari dua terminal berbeda:

- Transaksi 1: Membaca stok buku, lalu menunggu.

- Transaksi 2: Mengupdate stok buku yang sama.

- Amati apakah hasil pembacaan Transaksi 1 tetap konsisten setelah Transaksi 2 commit.

- Uji perbedaan perilaku antara READ COMMITTED vs REPEATABLE READ.

Sebagai Contoh:
```sql
-- Terminal 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT stock FROM books WHERE book_id = 5;
SELECT pg_sleep(30);
SELECT stock FROM books WHERE book_id = 5;
COMMIT;

-- Terminal 2
BEGIN;
UPDATE books SET stock = stock - 1 WHERE book_id = 5;
COMMIT;
```