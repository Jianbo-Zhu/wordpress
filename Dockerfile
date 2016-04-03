FROM php:5.6-apache
COPY html/ /var/www/html/


RUN apt-get update && apt-get install -y php5-mysql