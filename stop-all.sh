#!/bin/sh
bash -c 'cd ruby && docker-compose down --remove-orphans'
bash -c 'cd elixir && docker-compose down --remove-orphans'
bash -c 'cd go && docker-compose down --remove-orphans'
bash -c 'cd rust && docker-compose down --remove-orphans'
