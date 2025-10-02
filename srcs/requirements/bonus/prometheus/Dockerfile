# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache \
	prometheus

EXPOSE 9090

CMD ["--config.file=/etc/prometheus/prometheus.yml"]
