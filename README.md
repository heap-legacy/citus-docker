# citus-docker

Dockerfile for [CitusDB](citusdata.com), sharded scalable postgresql database.

## How to use this image

The image is based off of the [official postgres image](https://registry.hub.docker.com/_/postgres/) and supports the same options.

In addition, new environment variables have been added:

`CITUS_MASTER` denotes that this instance is the citus master node. All citus workers
should be linked to this container (and should contain `citus` in their name).


### Testing the image

The image defined in this repo can be tested using [docker compose](https://docs.docker.com/compose/).

To launch a citus cluster with a master node and 2 workers:

* `docker-compose up`

For an example for setting up a distributed table and on how to run queries on it,
see [CitusData docs: Examples with Sample Data](https://www.citusdata.com/docs/examples#amazon-reviews)

### How it works

For CitusDB to work its magic, it needs a full list of all citus workers in its
`pg_worker_list.conf` file.
