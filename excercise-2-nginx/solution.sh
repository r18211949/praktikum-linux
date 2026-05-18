#!/bin/bash
#buat folder output
mkdir -p output
echo "cukurukuk otw"

#Top 10 IP dengan request terbanyak
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -n 10 > output/top_10_ips.txt

#Hitung error rate (4xx + 5xx) per jam
echo -e "Jam | Total | Error | Rate%" > output/error_rate_per_hour.txt
awk '{
    # Ekstrak jam dari format [10/May/2026:14:23:45
    match($4, /:([0-9]{2}):/, h)
    jam = h[1]
    status = $9
    
    total[jam]++
    if (status >= 400 && status < 600) {
        error[jam]++
    }
} END {
     for (i=0; i<24; i++) {
        fmt_jam = sprintf("%02d", i)
        t = total[fmt_jam] ? total[fmt_jam] : 0
        e = error[fmt_jam] ? error[fmt_jam] : 0
        rate = t > 0 ? (e / t) * 100 : 0
        if (t > 0) {
            printf "%s:00 | %d | %d | %.2f%%\n", fmt_jam, t, e, rate >> "output/error_rate_per_hour.txt"
        }
    }
}' access.log

#Identifikasi suspected brute force (>50 request ke /login atau /admin)
awk '$7 ~ /\/login/ || $7 ~ /\/admin/ {print $1}' access.log | sort | uniq -c | awk '$1 > 50 {print "IP: " $2 " - Total Request: " $1}' > output/suspected_brute_force.txt

#Endpoint paling lambat (Top 10 rata-rata response time)
awk '{print $7, $NF}' access.log | awk '{sum[$1]+=$2; count[$1]++} END {for(e in sum) printf "%.2f ms - %s\n", sum[e]/count[e], e}' | sort -rn | head -n 10 > output/slowest_endpoints.txt

#Hitung total bytes transferred dan konversi ke MB/GB
awk '{sum+=$10} END {
    mb = sum / (1024 * 1024);
    gb = sum / (1024 * 1024 * 1024);
    printf "Total Bytes: %'\''d Bytes\nTotal Megabytes: %.2f MB\nTotal Gigabytes: %.4f GB\n", sum, mb, gb
}' access.log > output/total_bytes.txt

echo "=== cukurukuk selesai hasil di folder output/ ==="
