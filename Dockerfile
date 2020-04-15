FROM jrobinsonc/php:7.4-apache
# FROM jrobinsonc/wordpress:7.4-apache
# FROM jrobinsonc/drupal:7.4-apache
# FROM jrobinsonc/laravel:7.4-apache

# RUN apt-get update; \
#   rm -rf /var/lib/apt/lists/*;

# Installing mhsendmail for MailHog
# Visit the official Go downloads page and find the URL for the current binary release’s tarball
# https://golang.org/dl/
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN curl -fsSL https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz -o golang.tar.gz; \
  tar -zxvf golang.tar.gz; \
  rm golang.tar.gz; \
  mv go /usr/local; \
  mkdir $GOPATH
RUN go get github.com/mailhog/mhsendmail; \
  ln $GOPATH/bin/mhsendmail /usr/bin/mhsendmail; \
  ln $GOPATH/bin/mhsendmail /usr/bin/sendmail; \
  ln $GOPATH/bin/mhsendmail /usr/bin/mail

# Generate self-signed certificate for ssl module of Apache
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
  -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
  -subj "/C=US/ST=Ohio/L=Columbus/O=JRDev/OU=Development/CN=localhost"

# Installing XDebug
RUN pecl install xdebug; \
  docker-php-ext-enable xdebug

# Configuring Apache
RUN a2enmod ssl rewrite expires headers; \
  a2dissite 000-default

COPY ./conf/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY ./conf/httpd.conf /etc/apache2/sites-enabled/custom.conf
