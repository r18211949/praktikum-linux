#!/bin/bash
#buat folder output 
mkdir -p output

#Cari orderan yang kena BUG (total_amount != hasil penjumlahan qty * price)
echo -e "OrderID | CustomerID | TotalAmount | ActualSum" > output/buggy_orders.txt
jq -r '. | .order_id as $oid | .customer_id as $cid | .total_amount as $tam | (.items | map(.quantity * .price) | add) as $asum | select($tam != $asum) | "\($oid) | \($cid) | \($tam) | \($asum)"' orders.jsonl >> output/buggy_orders.txt

#Top 10 Customer ID yang paling sering belanja (Repeat Customers)
jq -r '.customer_id' orders.jsonl | sort | uniq -c | sort -rn | head -n 10 | awk '{print "CustomerID: " $2 " - Total Order: " $1}' > output/top_customers.txt

#Produk terlaris (Top 10 berdasarkan total quantity yang terjual)
jq -r '.items[] | "\(.product_name)\t\(.quantity)"' orders.jsonl | \
awk -F'\t' '{sum[$1]+=$2} END {for (p in sum) printf "%d unit - %s\n", sum[p], p}' | \
sort -rn | head -n 10 > output/top_products.txt

#Total pendapatan kotor (Revenue) dari seluruh order dari total_amount yang valid
jq -s 'map(.total_amount) | add' orders.jsonl | awk '{printf "Total Revenue: Rp %'\''d\n", $1}' > output/total_revenue.txt

#Rekap jumlah transaksi per tanggal
echo -e "Tanggal    | Jumlah Order" > output/orders_per_date.txt
jq -r '.order_date | sub("T.*"; "")' orders.jsonl | sort | uniq -c | awk '{print $2 " | " $1 " order"}' >> output/orders_per_date.txt

