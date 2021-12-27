# syntax=docker/dockerfile:1
FROM golang:1.17.5-bullseye
RUN apt-get update -qq
WORKDIR /code
COPY go.mod /code
COPY go.sum /code
COPY precompile.go /code
RUN go mod download && go run precompile.go
