FROM alpine:3.21

RUN apk add --no-cache busybox-extras

WORKDIR /var/www

COPY website/ .

EXPOSE 8079

CMD ["httpd", "-f", "-v", "-p", "8079"]

# https://wiki.alpinelinux.org/wiki/BusyBox
# https://hub.docker.com/_/busybox
# https://linux.die.net/man/1/busybox

# busybox devient httpd
# -f do not daemonize ? need tini ? on va voir
# -v verbose
# -p port binding -> 8080
