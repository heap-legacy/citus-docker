#!/bin/bash
set -e

function longestMatchingHost ()
{
  ip=$1
  cat /etc/hosts | \
    grep "$ip" | \
    grep -v "\.bridge" | \
    # Remove ip and junk info attached by docker
    cut -f2 | cut -f1 -d' ' | \
    # Take the longest match for this IP (e.g. projectname_citus_1)
    awk '{print $0" "length($0)}' | sort -k2,2rn | cut -f1 -d' ' | \
    head -n 1 | \
    xargs -I host echo -e "host\t5432"
}
export -f longestMatchingHost

# Update the worker listing on citus master, assumes that the citus are linked
# and have "citus" in their name
cat /etc/hosts | \
    grep "citus" | \
    # Find all unique IPs of linked citus images
    cut -f1 | \
    sort | \
    uniq | \
    xargs -I ip bash -c "longestMatchingHost ip" > "$PGDATA/pg_worker_list.conf"

if [ "$CITUS_STANDALONE" ]
then
  echo -e "localhost\t5432" >> "$PGDATA/pg_worker_list.conf"
fi
