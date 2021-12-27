#!/bin/sh
echo 'ruby'
bash -c 'cd ruby && ./build.sh'
echo '-----------------------------------------------'

echo 'elixir'
bash -c 'cd elixir && ./build.sh'
echo '-----------------------------------------------'
