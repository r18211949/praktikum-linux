#!/bin/bash


#buat folder output
mkdir -p output

#menghitung total,merapikan,dan mengitung dta kolom status
awk -F, 'NR>1 {print tolower($6)}' data.csv | sort | uniq -c > output/status_count.txt

#mencari format tgl dan mengubah oosisinya jadi yyyy/mm/dd
sed -E 's/([0-9]{2})\/([0-9]{2})\/([0-9]{4})/\3-\2-\1/g' data.csv > output/data_normalized_date.csv

#membuat file output gmail sekaligus menyaring customer gmail.com
head -n 1 data.csv > output/gmail-customer.csv
grep "gmail.com" data.csv >> output/gmail-customer.csv

#cek seluruh kolom email dan hapus baris kembar 
awk -F, 'NR==1 || !seen[$3]++' data.csv > output/data_clean_no_dupe.csv

#mendeteksi nama yg kapitalnya salah sekaligus hitung total baris
awk -F, 'NR>1 {if ($2 ~ /^[a-z ]+$/ || $2 ~ /[a-z][A-Z]/ || $2 ~ /[A-Z] {2,}/){print $2}}' data.csv | wc -l > output/invalid_capital_count.txt
