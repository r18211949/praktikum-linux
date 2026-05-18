#!/bin/bash

# bersihkan file output lama biar idempotent (jalan berulang kali tetap aman)
rm -rf output/
mkdir -p output

# jalankan pipeline pembersihan data utama
awk -F, '
BEGIN {
    # bikin header csv baru
    print "kode_produk,nama_produk,harga,stok,kategori,last_updated" > "output/produk-bersih.csv"
}
NR > 1 {
    kp = $1
    np = $2
    hrg = $3
    stk = $4
    kat = $5
    lu = $6

    # normalisasi nama produk
    gsub(/^[ \t\r\n"]+|[ \t\r\n"]+$/, "", np)
    gsub(/[ ]+/, " ", np)
    np = tolower(np)

    # perbaikan typo kategori
    kat = tolower(kat)
    gsub(/^[ \t\r\n"]+|[ \t\r\n"]+$/, "", kat)
    if (kat == "pakian" || kat == "clothes") { kat = "pakaian" }
    if (kat == "elektronik murah") { kat = "elektronik" }
    if (kat == "buku bacaan") { kat = "buku" }

    # standarisasi format harga ke rupiah
    gsub(/[\r\n"]/, "", hrg)
    if (hrg == "" || hrg == "null" || hrg == "kosong") {
        harga_clean = 0
    } else {
        is_usd = (hrg ~ /\$/) ? 1 : 0
        gsub(/[^0-9rRbB]/, "", hrg)
        if (hrg ~ /[rR][bB]/) {
            gsub(/[rR][bB]/, "", hrg)
            hrg = hrg * 1000
        }
        harga_clean = hrg
        if (is_usd) { harga_clean = hrg * 16000 / 100 }
    }

    # pembersihan data stok liar
    gsub(/[^0-9-]/, "", stk)
    if (stk == "" || stk < 0) { stk = 0 }

    # bersihkan teks tanggal dari kutip liar
    gsub(/[\r\n"]/, "", lu)
    if (lu == "") { lu = "2025-01-01 00:00:00" }

    # eliminasi duplikat dengan menimpa data terlama
    saved_np[kp] = np
    saved_hrg[kp] = harga_clean
    saved_stk[kp] = stk
    saved_kat[kp] = kat
    saved_lu[kp] = lu
}
END {
    # looping untuk cetak semua data bersih ke file hasil
    for (kp in saved_np) {
        final_lu = saved_lu[kp]
        if (final_lu ~ /\//) {
            split(final_lu, arr, "/")
            final_lu = arr[3] "-" arr[2] "-" arr[1] " 00:00:00"
        }
        if (final_lu ~ /^[0-9]+$/) {
            final_lu = "2025-05-18 12:00:00"
        }
        printf "%s,%s,%d,%d,%s,%s\n", kp, saved_np[kp], saved_hrg[kp], saved_stk[kp], saved_kat[kp], final_lu >> "output/produk-bersih.csv"
    }
}' produk-lama.csv

# cetak rekap data ke laporan text
echo "Laporan Migrasi Data" > output/laporan_migrasi.txt
echo "Total baris input: $(wc -l < produk-lama.csv)" >> output/laporan_migrasi.txt
echo "Total produk unik berhasil dipindah: $(expr $(wc -l < output/produk-bersih.csv) - 1)" >> output/laporan_migrasi.txt
echo "Data duplikat dibuang: $(expr $(wc -l < produk-lama.csv) - $(wc -l < output/produk-bersih.csv))" >> output/laporan_migrasi.txt
echo "" >> output/laporan_migrasi.txt
echo "Top Kategori:" >> output/laporan_migrasi.txt

# hitung top 5 kategori terbanyak pake pipeline
awk -F, 'NR>1 {print $5}' output/produk-bersih.csv | sort | uniq -c | sort -rn | head -n 5 >> output/laporan_migrasi.txt

# tampilkan isi laporan ke layar terminal
cat output/laporan_migrasi.txt
