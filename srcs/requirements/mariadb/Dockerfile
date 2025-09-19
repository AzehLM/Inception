# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache mariadb mariadb-client su-exec

VOLUME /var/lib/mysql

COPY tools/entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["./entrypoint.sh"]

CMD ["mariadbd"]
