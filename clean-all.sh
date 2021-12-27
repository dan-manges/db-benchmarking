#!/bin/bash
git clean -dfx
bash -c 'cd ruby && docker-compose rm --stop --force'
bash -c 'cd elixir && docker-compose rm --stop --force'
