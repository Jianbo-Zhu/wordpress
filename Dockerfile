FROM php:5.6-apache

# install the PHP extensions we need
RUN docker-php-ext-install mysqli \
	&& apt-get clean

# the app code goes here
COPY html/ /var/www/html/

CMD ["apache2-foreground"]