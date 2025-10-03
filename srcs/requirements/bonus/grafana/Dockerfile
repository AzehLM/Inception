# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache \
    grafana

RUN mkdir -p /var/lib/grafana \
    /etc/grafana/provisioning/datasources \
    /etc/grafana/provisioning/dashboards \
	/etc/grafana/provisioning/dashboards/json \
	/usr/share/grafana/data

RUN chown -R grafana:grafana /var/lib/grafana /etc/grafana /usr/share/grafana/data

EXPOSE 3000

USER grafana

CMD ["grafana-server", "--homepath=/usr/share/grafana", "--config=/etc/grafana.ini"]
