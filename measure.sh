#!/bin/bash
set -xv #echo on

rm bulk-read-benchmark.html

yaml_files=("100_bytes" "1_kbyte" "10_kbytes" "100_kbytes" "1_mbyte")
sizes=("1M" "1M" "100K" "10K" "1K")
title=bulk_read_by_partition_size

#yaml_files=("100_kbytes" "100_kbytes_with_100_rows" "100_kbytes_with_1000_rows")
#title=bulk_read_by_clustering_size

prefix="https://raw.githubusercontent.com/stef1927/cstar_bulk_read_test/master/"

for i in `seq 0 4`;
do
    yaml_file="${prefix}bulk_read_${yaml_files[$i]}.yaml"
    echo "Processing ${yaml_file}"
    ./tools/bin/cassandra-stress user profile=${yaml_file} ops\(insert=1\) n=${sizes[$i]} -rate threads=50
    ./tools/bin/cassandra-stress user profile=${yaml_file} ops\(all_columns_tr_query=1\) n=5K -rate threads=25 -tokenrange wrap -graph file=bulk-read-benchmark.html title=${title} revision=${yaml_files[$i]}
    cqlsh -e "drop keyspace bulk_read"
done

