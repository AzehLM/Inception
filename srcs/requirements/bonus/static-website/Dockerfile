FROM alpine:3.21

RUN apk add --no-cache busybox-extras

WORKDIR /var/www

COPY website/ .

EXPOSE 8079

CMD ["httpd", "-f", "-v", "-p", "8079"]
