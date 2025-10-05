# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache \
	prometheus

EXPOSE 9090

CMD ["prometheus", "--config.file=/etc/prometheus/prometheus.yml", \
     "--web.external-url=https://gueberso.42.fr/prometheus/", \
     "--web.route-prefix=/"]

# check last two line if essential
