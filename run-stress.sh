#!/bin/bash
set -xv #echo on

pid=`pgrep java`
echo $pid

#revisions=("100_bytes" "1_kbyte" "10_kbytes" "100_kbytes" "1_mbyte" "100_kbytes_with_100_rows" "100_kbytes_with_1000_rows")
revision="10_kbytes"

title=bulk_read
prefix="https://raw.githubusercontent.com/stef1927/cstar_bulk_read_test/master/"
yaml_file="${prefix}bulk_read_${revision}.yaml"
graph_file=bulk-read-benchmark-${revision}.html

rm ${graph_file}

jcmd $pid JFR.start name=$revision
./tools/bin/cassandra-stress user profile=${yaml_file} ops\(all_columns_tr_query=1\) n=10K -rate threads=1 -tokenrange wrap -graph file=${graph_file} title=${title} revision=${revision} op=bulk_read
jcmd $pid JFR.dump name=$revision filename=cassandra.$revision.jrf
jcmd $pid JFR.stop name=$revision
