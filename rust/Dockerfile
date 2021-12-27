# syntax=docker/dockerfile:1
FROM rust:1.57.0-buster
RUN apt-get update -qq
WORKDIR /code/benchmarking
COPY benchmarking/Cargo.lock ./
COPY benchmarking/Cargo.toml ./
RUN mkdir src && echo 'fn main() {}' > src/main.rs && cargo build
