# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache \
	php83 \
	php83-phar \
	php83-fpm \
	php83-mysqli \
	php83-mbstring \
	php83-opcache \
	# importing redis since we'll need to for the bonus service
	redis \
	# native PHP support to connect to Redis servers
	php83-redis

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
