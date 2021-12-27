# syntax=docker/dockerfile:1
FROM rust:1.57.0-buster
RUN apt-get update -qq
WORKDIR /code
COPY benchmarking/Cargo.lock /code
COPY benchmarking/Cargo.toml /code
RUN mkdir src && echo 'fn main() {}' > src/main.rs && cargo build
