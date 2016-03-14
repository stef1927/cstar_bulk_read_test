#!/bin/bash

export page_size=5000

value_sizes=("50" "512" "5120" "51200" "524288")
table_names=("100_bytes" "1_kbyte" "10_kbytes" "100_kbytes" "1_mbyte")

for i in `seq 0 4`
do
	export clustering_size="1"
	export value_size=${value_sizes[$i]}
	export table_name="data_${table_names[$i]}"

	echo "Generating ${table_name}"
	envsubst < bulk_read_template.yaml > bulk_read_${table_names[$i]}.yaml
done


value_sizes=("512" "50")
clustering_sizes=("100" "1000")
for i in `seq 0 1`
do
	export clustering_size=${clustering_sizes[$i]}
	export value_size=${value_sizes[$i]}
	name="100_kbytes_with_${clustering_size}_rows"
	export table_name="data_${name}"

	echo "Generating ${table_name}"
	envsubst < bulk_read_template.yaml > bulk_read_${name}.yaml
done


