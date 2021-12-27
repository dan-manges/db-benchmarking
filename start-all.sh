#!/bin/sh
bash -c 'cd ruby && docker-compose up --remove-orphans -d'
bash -c 'cd elixir && docker-compose up --remove-orphans -d'
