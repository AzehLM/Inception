# syntax=docker/dockerfile:1

FROM alpine:3.21

# Added curl so the healtcheck can run properly
RUN apk add --no-cache \
	nginx \
	curl

RUN mkdir -p /etc/nginx/locations

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/services.conf /etc/nginx/http.d/
COPY conf/locations/*.inc /etc/nginx/locations/

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
