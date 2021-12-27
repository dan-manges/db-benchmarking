#!/bin/bash
set -e

exec > >(tee -i latest_run.log)

echo 'ruby'
bash -c 'cd ruby && ./run.sh'
echo '-----------------------------------------------'

echo 'elixir'
bash -c 'cd elixir && ./run.sh'
echo '-----------------------------------------------'

echo 'go'
bash -c 'cd go && ./run.sh'
echo '-----------------------------------------------'

echo 'rust'
bash -c 'cd rust && docker-compose run app'
echo '-----------------------------------------------'
