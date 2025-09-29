# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache redis

WORKDIR /app

EXPOSE 6379

ENTRYPOINT ["redis-server", "--protected-mode no"]
