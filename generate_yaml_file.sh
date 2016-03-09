#!/bin/bash

export page_size=5000

for cs in $( echo "1 10 100 1K" ); do
	for vs in $( echo "50 500 5K 500K 5M" ); do
		export value_size=$vs
		export clustering_size=$cs
		export table_name=value${value_size}_cluster${clustering_size}
		echo "Generating ${table_name}"
		
		envsubst < bulk_read_template.yaml > bulk_read_${table_name}.yaml
	done
done


