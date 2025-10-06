# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache \
	libc6-compat \
	wget

RUN wget -O /usr/local/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.53.0/cadvisor-v0.53.0-linux-amd64 \
    && chmod +x /usr/local/bin/cadvisor

EXPOSE 8080

CMD ["cadvisor"]

# https://github.com/google/cadvisor/releases/download/v0.39.3/cadvisor
# https://github.com/google/cadvisor/releases/download/v0.53.0/cadvisor
# https://github.com/google/cadvisor/releases/tag/v0.53.0/download/cadvisor


# https://github.com/google/cadvisor/archive/refs/tags/v0.52.1.zip
