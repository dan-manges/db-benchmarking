#!/bin/bash
set -e

exec > >(tee -i latest_run.log)

echo 'ruby'
bash -c 'cd ruby && docker-compose run --rm app'
echo '-----------------------------------------------'

echo 'elixir'
bash -c 'cd elixir && docker-compose run --rm app'
echo '-----------------------------------------------'

echo 'go'
bash -c 'cd go && docker-compose run --rm app'
echo '-----------------------------------------------'

echo 'rust'
bash -c 'cd rust && docker-compose run --rm app'
echo '-----------------------------------------------'
