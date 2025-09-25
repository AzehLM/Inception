# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache \
	# process manager needed for nginx to serve php
	# DELETE THOSE TWO ?
	# only to test php wp-cli.phar --info
	php83 \
	php83-phar \
	php83-fpm \
	mariadb-client \
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
	# native PHP support to connect to Redis servers
	php83-redis
	# php83-json: is built-in alpine apparently
	# php83-tokenizer: doubt if I will really have use of this

	# php83-xml: required for XML parsing. WordPress core and several plugins depend on this
	# php83-zip: Necessary for installing/updating plugins and themes via the admin interface.
	# php83-ctype: Required for character type functions; many extensions and WordPress core expect it to be present
# necessary to avoid wp core download fail
RUN echo "memory_limit = 256M" >> /etc/php83/php.ini

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

EXPOSE 9000

RUN adduser -D -S -G www-data -u 82 www-data

ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["php-fpm83", "-F"]



# potential helper later on
# RUN ln -sf /usr/bin/php83 /usr/bin/php || true
