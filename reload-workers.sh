#!/bin/bash
set -e

touch /tmp/worker_names_tmp

# Update the worker listing on citus master, assumes that the citus are linked
# and have "citus" in their name
cat /etc/hosts | \
    grep "citus" | \
    # Find all lines for links which have aliases
    egrep "^[0-9.]+\s+\w+\s+\w+\s+\w+$" | \
    # take all "original container names" from these aliases (last field)
    cut -f2 | cut -f3 -d' ' >> /tmp/worker_names_tmp

cat /etc/hosts | \
    grep "citus" | \
    # Find all lines for links which don't have aliases
    egrep "^[0-9.]+\s+\w+\s+\w+$" | \
    # take all container names
    cut -f2 | cut -f1 -d' ' >> /tmp/worker_names_tmp

cat /tmp/worker_names_tmp | sort | uniq > "$PGDATA/pg_worker_list.conf"
rm /tmp/worker_names_tmp


if [ "$CITUS_STANDALONE" ]
then
  echo -e "localhost\t5432" >> "$PGDATA/pg_worker_list.conf"
fi

# Example /etc/hosts file:
#   172.17.0.41     13629b35f281
#   127.0.0.1       localhost
#   ::1     localhost ip6-localhost ip6-loopback
#   fe00::0 ip6-localnet
#   ff00::0 ip6-mcastprefix
#   ff02::1 ip6-allnodes
#   ff02::2 ip6-allrouters
#   172.17.0.37     citus2_1 87d502094859 heap_citus2_1
#   172.17.0.40     citus_1 f8d41b57f49d heap_citus_1
#   172.17.0.37     heap_citus2_1 87d502094859
#   172.17.0.40     heap_citus_1 f8d41b57f49d
#   172.17.0.40     citus f8d41b57f49d heap_citus_1
#   172.17.0.37     citus2 87d502094859 heap_citus2_1
#   172.17.0.37     heap_citus2_1
#   172.17.0.38     heap_zookeeper_1.bridge
#   172.17.0.39     heap_redis_1
#   172.17.0.40     heap_citus_1.bridge
#   172.17.0.41     heap_citusmaster_1.bridge
#   172.17.0.36     heap_postgres_1.bridge
#   172.17.0.37     heap_citus2_1.bridge
#   172.17.0.39     heap_redis_1.bridge
#   172.17.0.41     heap_citusmaster_1
#   172.17.0.38     heap_zookeeper_1
#   172.17.0.40     heap_citus_1
#   172.17.0.36     heap_postgres_1
#   172.17.0.42     heap_kafka_1
#   172.17.0.42     heap_kafka_1.bridge
# Here the `heap_citus_1` and `heap_citus2_1` rows will be added to the worker list.
