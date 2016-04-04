# citus-docker

Dockerfile for [CitusDB](https://www.citusdata.com), sharded scalable postgresql database.

## How to use this image

The image is based off of the [official postgres image](https://registry.hub.docker.com/_/postgres/) and supports the same options. When used with the provided `docker-compose` configuration, a [`workerlist-gen` container](https://hub.docker.com/r/citusdata/workerlist-gen/) is responsible for updating the worker list file and signalling the master node to reload changes.

### Testing the image

The image defined in this repo can be tested using [docker compose](https://docs.docker.com/compose/).

To launch a minimal Citus cluster (one master and one worker): `docker-compose -p citus up`. The `-p` flag specifies a custom project name (defaults to current working directory's name, which is often unsightly).

To bring the worker count up to three: `docker-compose -p citus scale worker=3`

For an example for setting up a distributed table and on how to run queries on it,
see [Querying Raw Data — CitusDB Documentation](https://www.citusdata.com/documentation/citusdb-documentation/examples/time_querying_raw_data.html).

These commands should be run from inside your Docker instance:

```bash
docker exec -it citus_master bash
apt-get update; apt-get install -y wget
wget http://examples.citusdata.com/github_archive/github_events-2015-01-01-{0..5}.csv.gz
gzip -d github_events-2015-01-01-*.gz
psql

# See the CitusDB guide (linked above) for remaining steps
```
