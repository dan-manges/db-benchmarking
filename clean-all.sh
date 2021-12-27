#!/bin/bash
set -e
git clean -dfX
bash -c 'cd ruby && docker-compose rm --stop --force'
bash -c 'cd elixir && docker-compose rm --stop --force'
bash -c 'cd go && docker-compose rm --stop --force'
bash -c 'cd rust && docker-compose rm --stop --force'
