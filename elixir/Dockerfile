# syntax=docker/dockerfile:1
FROM elixir:1.13.1
RUN apt-get update -qq
RUN bash -c 'mix local.hex --force && mix local.rebar --force'
