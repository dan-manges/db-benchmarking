#!/bin/sh
bash -c 'cd ruby && docker-compose up --remove-orphans -d db'
bash -c 'cd elixir && docker-compose up --remove-orphans -d db'
bash -c 'cd go && docker-compose up --remove-orphans - d db'
bash -c 'cd rust && docker-compose up --remove-orphans -d db'
