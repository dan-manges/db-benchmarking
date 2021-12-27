#!/bin/sh
echo 'ruby'
bash -c 'cd ruby && docker-compose build app'
echo '-----------------------------------------------'

echo 'elixir'
bash -c 'cd elixir && ./build.sh'
echo '-----------------------------------------------'

echo 'go'
bash -c 'cd go && docker-compose build app'
echo '-----------------------------------------------'

echo 'rust'
bash -c 'cd rust && ./build.sh'
echo '-----------------------------------------------'
