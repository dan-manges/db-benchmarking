#!/bin/bash
set -e

./clean-all.sh
./build-all.sh
./start-all.sh
./run-all.sh
./stop-all.sh
