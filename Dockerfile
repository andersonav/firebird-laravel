# Use a imagem base PHP com FPM
FROM php:8.3-fpm

# Defina variáveis de ambiente
ARG user=alves
ARG uid=1000
ENV FBURL=https://github.com/FirebirdSQL/firebird/releases/download/v5.0.0/Firebird-5.0.0.1306-0-linux-x64.tar.gz

# Instale as dependências do sistema
RUN apt-get update && apt-get install -qy \
    libatomic1 \
    libncurses6 \
    libtomcrypt1 \
    libtommath1 \
    netbase \
    procps \
    libncurses5-dev \
    libncursesw5-dev \
    ca-certificates \
    curl \
    expect \
    g++ \
    gcc \
    libicu-dev \
    libncurses-dev \
    libtomcrypt-dev \
    libtommath-dev \
    make \
    unzip \
    xz-utils \
    zlib1g-dev \
    git \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip

# Baixe e extraia o Firebird
RUN curl -L ${FBURL} | tar -zxC /tmp

RUN mv /tmp/Firebird-5.0.0.1306-0-linux-x64 /tmp/firebird

COPY docker/firebird/install.sh /tmp/firebird/install_mode.sh

# Crie e torne executável o script expect para automatizar a instalação
RUN cd /tmp/firebird/
RUN cp /tmp/firebird/manifest.txt /var/www/html/manifest.txt 
RUN cp /tmp/firebird/buildroot.tar.gz /var/www/html/buildroot.tar.gz 
RUN chmod +x /tmp/firebird/install_mode.sh

# Execute o script expect para instalar o Firebird
RUN /tmp/firebird/install_mode.sh -silent -path /opt/firebird

COPY docker/firebird/iberror_c.h /usr/include/firebird/impl/iberror_c.h
COPY docker/firebird/iberror_c.h /opt/firebird/include/firebird/impl/iberror_c.h

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install intl pdo_firebird mbstring exif pcntl bcmath gd sockets soap

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
# Crie usuário e configure permissões
RUN useradd -G www-data,root -u $uid -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user && \
    echo "$user:$user" | chpasswd && \
    adduser $user sudo

# Set working directory
WORKDIR /var/www
RUN chmod -R 777 /var/www

# # Copy custom configurations PHP
COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/php/fpm/www.conf /usr/local/etc/php/php-fpm.d/www.conf

USER root