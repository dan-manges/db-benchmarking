#!/bin/bash
set -e

./clean-all.sh
./start-all.sh
./build-all.sh
./run-all.sh
./stop-all.sh
