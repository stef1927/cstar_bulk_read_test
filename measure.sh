#!/bin/bash
set -xv #echo on

#rm bulk-read-benchmark.html

yaml_files=("100_bytes" "1_kbyte" "10_kbytes" "100_kbytes" "1_mbyte" "100_kbytes_with_100_rows" "100_kbytes_with_1000_rows")
sizes=("1M" "1M" "1M" "250K" "25K" "250K" "250K")
title=bulk_read_by_partition_size
threads=("50" "50" "10" "1" "1" "1" "1")

#conf/cassandra.yaml:
#write_request_timeout_in_ms: 30000
#compaction_throughput_mb_per_sec: 0
#batch_size_warn_threshold_in_kb: 100
#batch_size_fail_threshold_in_kb: 200


prefix="https://raw.githubusercontent.com/stef1927/cstar_bulk_read_test/master/"

for i in `seq 5 6`;
do
    yaml_file="${prefix}bulk_read_${yaml_files[$i]}.yaml"
    echo "Processing ${yaml_file}"
    #./tools/bin/cassandra-stress user profile=${yaml_file} ops\(insert=1\) n=${sizes[$i]} no-warmup -rate threads=${threads[$i]}
    ./tools/bin/cassandra-stress user profile=${yaml_file} ops\(all_columns_tr_query=1\) n=30K -rate threads=1 -tokenrange wrap -graph file=bulk-read-benchmark.html title=${title} revision=${yaml_files[$i]} op=bulk_read
    #cqlsh -e "drop keyspace bulk_read"
done

