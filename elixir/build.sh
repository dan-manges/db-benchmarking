#!/bin/sh
docker-compose build app
docker-compose run app bash -c 'cd /code/benchmarking && mix deps.get --force && mix compile --force'
