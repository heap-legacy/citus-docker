#!/bin/bash
set -e

# Update the worker listing on citus master, assumes that the citus are linked
# and have "citus" in their name
cat /etc/hosts | \
    grep "citus" | \
    # :TRICKY: order citus hosts alphabetically, in hopes similar entries are
    # grouped together. This makes the hostnames in worker list predictable.
    sort -k 1,1 -k 2,2 | sort -k 1,1 -u | \
    cut -f2 | \
    xargs -I host echo "host 5432" > "$PGDATA/pg_worker_list.conf"
