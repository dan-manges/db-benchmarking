#!/bin/sh
bash -c 'cd ruby && docker-compose up --remove-orphans -d app'
bash -c 'cd elixir && docker-compose up --remove-orphans -d app'
bash -c 'cd go && docker-compose up --remove-orphans -d app'
bash -c 'cd rust && docker-compose up --remove-orphans -d app'
