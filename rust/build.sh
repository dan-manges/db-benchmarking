#!/bin/sh
set -e
docker-compose build app
docker-compose run app bash -c 'cd /code/benchmarking && cargo build'
