# syntax=docker/dockerfile:1
FROM elixir:1.13.1
RUN apt-get update -qq
RUN mkdir -p /code/benchmarking/lib
COPY benchmarking/lib/benchmarking.ex /code/benchmarking/lib
COPY benchmarking/mix.exs /code/benchmarking
RUN bash -c 'cd /code/benchmarking && mix local.hex --force && mix local.rebar --force && mix deps.get --force && mix compile --force'
