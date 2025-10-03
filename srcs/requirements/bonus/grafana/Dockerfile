# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache \
    grafana

RUN mkdir -p /var/lib/grafana \
    /usr/share/grafana/conf/provisioning/datasources \
    /usr/share/grafana/conf/provisioning/dashboards \
    /usr/share/grafana/conf/provisioning/dashboards/json \
    /usr/share/grafana/data

RUN chown -R grafana:grafana /var/lib/grafana /usr/share/grafana

EXPOSE 3000

USER grafana

CMD ["grafana-server", "--homepath=/usr/share/grafana", "--config=/etc/grafana.ini"]
