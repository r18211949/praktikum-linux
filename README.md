# README - Praktikum Sistem Operasi

## Identitas Mahasiswa

* **Nama:** Rusdi Aditya
* **NIM:** 251552010022
* **Mata Kuliah:** Sistem Operasi

---

# Praktikum SCP & Verifikasi SHA



---

# 1. Login SSH ke Ubuntu VM

Perintah yang digunakan untuk login ke Ubuntu VM:

```bash
ssh cukurukuk@192.168.56.101
```

Keterangan:

* `cukurukuk` = username Linux
* `192.168.56.101` = IP address Ubuntu VM

---

# 2. Transfer File Menggunakan SCP

Perintah yang digunakan:

```powershell
scp -r cukurukuk@192.168.56.101:~/praktikum $env:USERPROFILE\Downloads
```

Keterangan:

* `-r` digunakan untuk menyalin folder secara rekursif.
* Folder `praktikum` dari Ubuntu VM disalin ke folder `Downloads` di Windows.

File yang berhasil dipindahkan antara lain:

* `orders.jsonl`
* `top_products.txt`
* `migration.sh`
* `produk-bersih.csv`
* `access.log`
* `status_count.txt`
* dan file lainnya.

Proses transfer berhasil dilakukan tanpa error.

---

# 3. Verifikasi Integritas File Menggunakan SHA256

Setelah file dipindahkan, dilakukan pengecekan hash SHA256 untuk memastikan file di laptop dan Ubuntu identik.

## Hasil SHA256

### Laptop

```text
6BB07C2391FDE8156640539055BA072D7581C40A8D0317665FE187BA6A0BE19D
```

### Ubuntu

```text
6BB07C2391FDE8156640539055BA072D7581C40A8D0317665FE187BA6A0BE19D
```

## Kesimpulan Verifikasi

Karena nilai hash SHA256 pada laptop dan Ubuntu sama persis, maka file berhasil dipindahkan tanpa kerusakan ataupun perubahan data.

---

# Dokumentasi Praktikum

## SSH User

<img width="1920" height="1080" alt="ssh user" src="https://github.com/user-attachments/assets/96bb8ee8-1b60-4a73-a192-51f653a961b9" />

---

## Proses SCP

<img width="1920" height="1080" alt="scp" src="https://github.com/user-attachments/assets/13c2466e-7688-4ce4-a475-d5738b1fe8b5" />

---

## Hasil Folder

<img width="1920" height="1080" alt="Screenshot (33)" src="https://github.com/user-attachments/assets/6c1be697-6d07-4719-ade6-be227a0e6957" />

---

## Verifikasi SHA256

<img width="1920" height="1080" alt="sha1" src="https://github.com/user-attachments/assets/3bd91358-21fc-44ae-a57b-e1a2edbfd867" />

---

# Catatan Singkat: Kelebihan & Kekurangan SCP vs RSYNC

## 1. SCP (Secure Copy Protocol)

### Kelebihan

* Sangat simpel dan mudah digunakan.
* Sintaks mirip dengan perintah `cp`.
* Tidak perlu instalasi tambahan karena sudah bawaan SSH.
* Cocok untuk transfer file kecil atau file tunggal.

### Kekurangan

* Tidak bisa melanjutkan transfer jika terputus.
* Selalu menyalin ulang seluruh file.
* Kurang efisien untuk sinkronisasi folder besar.

---

## 2. RSYNC (Remote Synchronization)

### Kelebihan

* Mendukung delta transfer (hanya bagian yang berubah yang dikirim).
* Bisa resume transfer jika koneksi terputus.
* Mendukung kompresi data saat transfer.
* Lebih efisien untuk folder besar.

### Kekurangan

* Sintaks lebih kompleks.
* Membutuhkan instalasi `rsync` di kedua perangkat.
* Penggunaan flag cukup banyak dan membingungkan bagi pemula.

---

# Kesimpulan & Preferensi Pribadi

Untuk kebutuhan praktikum ini, penggunaan `scp` lebih praktis dan cepat karena file yang dipindahkan relatif kecil dan sederhana. Selain itu, sintaksnya mudah dipahami sehingga mempercepat proses pengerjaan praktikum.

Namun, untuk transfer data besar atau sinkronisasi file secara berkala, `rsync` lebih unggul karena lebih efisien dan mendukung resume transfer.

---

# Kesimpulan Akhir

Praktikum berhasil dilakukan dengan baik:

* SSH berhasil terkoneksi ke Ubuntu VM.
* Transfer file menggunakan SCP berhasil.
* Verifikasi SHA256 menunjukkan file identik.
* Praktikum memberikan pemahaman mengenai transfer file Linux serta pengecekan integritas data.
* soal excercise 1 sampai 4 selesai dan berjalan 
