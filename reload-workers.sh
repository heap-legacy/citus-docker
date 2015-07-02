#!/bin/bash
set -e

# Update the worker listing on citus master, assumes that the citus are linked
# and have "citus" in their name
cat /etc/hosts | \
    grep "citus" | \
    # Remove ip and junk info attached by docker
    cut -f2 | cut -f1 -d' ' | \
    # :TRICKY: order citus hosts alphabetically, in hopes similar entries are
    # grouped together. This makes the hostnames in worker list predictable.
    sort | \
    uniq | \
    xargs -I host echo -e "host\t5432" >> "$PGDATA/pg_worker_list.conf"

if [ "$CITUS_STANDALONE" ]
then
  echo -e "localhost\t5432" >> "$PGDATA/pg_worker_list.conf"
fi
