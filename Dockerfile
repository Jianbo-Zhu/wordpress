FROM php:5.6-apache
COPY html/ /var/www/html/


RUN apt-get install php5-mysql