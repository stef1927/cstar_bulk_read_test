#!/bin/bash

export page_size=5000

# the value sizes are chosen so that two columns with this size give the size described in the table name
value_sizes=("25" "50" "512" "5120" "51200" "524288")
table_names=("50_bytes" "100_bytes" "1_kbyte" "10_kbytes" "100_kbytes" "1_mbyte")
# the page size is chosen so that each operation (a page size download) corresponds to 1MB
page_sizes=("20000" "10000" "1000" "100" "10" "1")

for i in `seq 0 5`
do
	export clustering_size="1"
	export value_size=${value_sizes[$i]}
	export table_name="data_${table_names[$i]}"
	export page_size=${page_sizes[$i]}

	echo "Generating ${table_name}"
	envsubst < bulk_read_template.yaml > bulk_read_${table_names[$i]}.yaml
done


value_sizes=("512" "50")
clustering_sizes=("100" "1000")
page_sizes=("1000" "10000")
for i in `seq 0 1`
do
	export clustering_size=${clustering_sizes[$i]}
	export value_size=${value_sizes[$i]}
	name="100_kbytes_with_${clustering_size}_rows"
	export table_name="data_${name}"
	export page_size=${page_sizes[$i]}

	echo "Generating ${table_name}"
	envsubst < bulk_read_template.yaml > bulk_read_${name}.yaml
done


