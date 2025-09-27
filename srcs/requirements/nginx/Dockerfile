# syntax=docker/dockerfile:1

FROM alpine:3.21

# Added curl so the healtcheck can run properly
RUN apk add --no-cache nginx curl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/http.d/

COPY conf/website.conf /etc/nginx/http.d/

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
