# syntax=docker/dockerfile:1

FROM alpine:3.21


RUN apk add --no-cache \
	# process manager needed for nginx to serve php
	php83-fpm \
	# connect for Wordpress to connect to mariadb
	# if it doesnt work change or add mysqlnd, should work together
	php83-mysqli \
	# handle multibty string, required by Wordpress
	php83-mbstring \
	# Not sure yet if I keep this, use for HTTP requests and API calls (how does the client communicate with the server)
	php83-curl \
	# performance improvement
	php83-opcache \
	# importing redis since we'll need to for the bonus service
	redis \
	# native PHP support for connecting to Redis servers
	php83-redis

	# php83-json: is built-in alpine apparently
	# php83-tokenizer: doubt if I will really have use of this

	# php83-xml: required for XML parsing. WordPress core and several plugins depend on this
	# php83-zip: Necessary for installing/updating plugins and themes via the admin interface.
	# php83-ctype: Required for character type functions; many extensions and WordPress core expect it to be present

COPY conf/www.conf /etc/php83/www.conf
COPY tools/entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

EXPOSE 9000

ENTRYPOINT [ "./entrypoint.sh" ]
