# citus-docker

Dockerfile for [CitusDB](https://www.citusdata.com), sharded scalable postgresql database.

## How to use this image

The image is based off of the [official postgres image](https://registry.hub.docker.com/_/postgres/) and supports the same options.

In addition, new environment variables have been added:

`CITUS_MASTER` denotes that this instance is the citus master node. All citus workers
should be linked to this container (and should contain `citus` in their name).

`CITUS_STANDALONE` marks a citus master as a worker as well.

### Testing the image

The image defined in this repo can be tested using [docker compose](https://docs.docker.com/compose/).

To launch a citus cluster with a master node and 2 workers:

* `docker-compose up`

For an example for setting up a distributed table and on how to run queries on it,
see [CitusData docs: Examples with Sample Data](https://www.citusdata.com/docs/examples#amazon-reviews).

These commands should be run from inside your docker instance:

```bash
> docker exec -it citusdocker_citusmaster_1 bash
root@9f7103615071:/# apt-get update; apt-get install -y wget
root@9f7103615071:/# wget http://examples.citusdata.com/customer_reviews_1998.csv.gz
root@9f7103615071:/# wget http://examples.citusdata.com/customer_reviews_1999.csv.gz
root@9f7103615071:/# gzip -d *.csv.gz
root@9f7103615071:/# psql
# follow the rest of the guide from here
```
