# Tugas Asistensi Praktikum Modul 1: Indexing

## Catatan
- Kerjakan tugas ini secara individu.
- Tugas ini harus dikerjakan di database `tugasasis_indexing` yang telah Anda buat sebelumnya.
- Tugas dikerjakan dengan LaTeX dan dikumpulkan dalam format PDF, sertakan screenshot hasil `EXPLAIN ANALYZE` dari query yang telah Anda jalankan atau boleh setiap langkah yang Anda lakukan.
- Gunakan format penulisan yang baik dan benar, serta gunakan bahasa Indonesia yang baku.
- Kirimkan hasil tugas ke WhatsApp asisten (https://wa.me/6285234115941) dengan format nama file `TugasAsistensi_(NoKelompok)_(NRP)_(Nama Lengkap).pdf`.
  > (contoh: `TugasAsistensi_10_5024221058_Rigel Ramadhani Waloni.pdf`).
- **Batas pengumpulan tugas adalah sebelum agenda Asistensi pada tanggal `18 Mei 2025 pukul 09.00 WIB`.**
- Jika ada kendala dalam mengerjakan tugas, silahkan bisa ditanyakan melalui WhatsApp.

## Setup Awal (Database Baru, Tabel, dan Import Data CSV)
1. Silahkan clone repositori ini ke dalam folder lokal.
2. Pastikan Docker sudah terinstall dan container yang digunakan saat praktikum sebelumnya sudah berjalan.
3. Buka terminal dan cd ke folder `praktikum1_indexing > scripts` di repositori ini (sudah di-clone).
4. Jalankan perintah berikut untuk mengimpor data ke database :
```bash
bash import_data.sh
```
5. Tunggu hingga proses selesai. Setelah itu, Anda dapat memeriksa data dengan membuka PGAdmin dengan langkah-langkah pada repo praktikum.

6. Data sudah siap digunakan untuk tugas ini.

<br>

## Soal Partial Index dan Expression-Based Index

**Pastikan untuk:**
- Bandingkan actual time, I/O, dan planning time.
- Bahas trade-off antara read-performance dan write-overhead.

Tabel **messages** menyimpan pesan antar-pengguna
> Catatan: Praktikan tidak perlu menjalankan lagi query ini karena sudah ada di dalam file `import_data.sh`:
```sql
CREATE TABLE messages (
  msg_id       SERIAL PRIMARY KEY,
  sender_id    INTEGER,
  recipient_id INTEGER,
  sent_at      TIMESTAMP,
  is_read      BOOLEAN DEFAULT FALSE,
  content      TEXT
);
```

Ada dua pola query yang sangat sering:
- **Query A**: Ambil semua pesan belum terbaca untuk penerima tertentu
```sql
SELECT * FROM messages
WHERE recipient_id = 42
  AND is_read = FALSE
ORDER BY sent_at;
```

- **Query B**: Cari kata kunci case-insensitive di isi pesan
```sql
SELECT msg_id, sender_id, sent_at
FROM messages
WHERE LOWER(content) LIKE '%list%';
```

**Pertanyaan:**
1. **Tanpa index**:
    - Jalankan `EXPLAIN ANALYZE` untuk Query A dan Query B tanpa membuat index.
    - Catat actual time dan jumlah baris yang dipindai.

2. **Partial Index untuk Query A**:
    - Buat partial index untuk Query A.
    ```sql
    CREATE INDEX idx_msg_unread_recipient ON messages(recipient_id, sent_at) WHERE is_read = FALSE;
    ```
    - Jalankan `EXPLAIN ANALYZE` untuk Query A setelah membuat index.
    - Jelaskan seberapa besar penurunan cost dan rows yang dibaca serta kelebihan dan kekurangan partial index dibanding index biasa!

3. **Expression Index untuk Query B**:
    - Buat expression index untuk Query B.
    ```sql
    CREATE INDEX idx_msg_content_lower ON messages (LOWER(content) varchar_pattern_ops);
    ```
    - Jalankan `EXPLAIN ANALYZE` untuk Query B setelah membuat index.
    - Bagaimana index ini mempercepat `LIKE '%…%'` case-insensitive?
    - Dampak pada maintenance (INSERT/UPDATE) dan ukuran index.