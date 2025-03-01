# Use official PHP image with Apache
FROM php:8.2-apache

# Install dependencies for WordPress
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql

# Enable Apache rewrite module (for permalinks)
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Download and extract WordPress
RUN curl -o wordpress.tar.gz -fSL "https://wordpress.org/latest.tar.gz" \
    && tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm wordpress.tar.gz \
    && chown -R www-data:www-data /var/www/html

# Copy custom configuration (optional, if you have one)
# COPY wp-config.php /var/www/html/wp-config.php

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]