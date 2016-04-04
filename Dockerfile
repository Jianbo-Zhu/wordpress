FROM 172.30.71.9:5000/shiftwork/wordpress

COPY html/ /var/www/html/

COPY apache2-foreground /usr/local/bin/apache2-foreground

RUN chmod +x /usr/local/bin/apache2-foreground
