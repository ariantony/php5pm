FROM ubuntu:18.04
MAINTAINER Tony Arianto <tony.arianto@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -m harvest && echo "harvest:s1harvest123" | chpasswd
RUN adduser harvest sudo
RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    git \
    apache2 \
    libapache2-mod-php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl \
    php-imagick \
    php-bcmath \
    # Install tools
    nano \
    supervisor \
    mysql-client \
    iputils-ping \
    locales \
    ca-certificates \
    proftpd \
    cron \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/supervisor/conf.d/
RUN sed -i "s|# DefaultRoot|DefaultRoot |g" /etc/proftpd/proftpd.conf
RUN rm /etc/apache2/sites-available/000-default.conf
ADD 000-default.conf /etc/apache2/sites-available/

RUN a2ensite 000-default
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo "Asia/Jakarta" > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

EXPOSE 80 443 22 21
WORKDIR /var/www/html/public
CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
