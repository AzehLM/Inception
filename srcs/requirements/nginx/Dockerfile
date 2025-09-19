# syntax=docker/dockerfile:1

FROM alpine:3.21

# Added curl so the healtcheck can run properly
RUN apk add --no-cache nginx openssl curl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/http.d/

RUN mkdir -p /etc/nginx/ssl

# Need to check what this does
RUN openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem \
    -sha256 -days 365 -nodes \
    -subj "/C=FR/ST=France/L=Lyon/O=42lyon/OU=DevOps/CN=localhost"

EXPOSE 443

# Still need to check what each of those parameter does
ENTRYPOINT ["nginx", "-g", "daemon off;"]
