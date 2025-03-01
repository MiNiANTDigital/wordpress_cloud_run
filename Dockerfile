# Use official PHP image with Apache
FROM php:8.2-apache

# Install dependencies for WordPress
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql

# Enable Apache rewrite module (for permalinks)
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy the WordPress files from your repo into the container
COPY . /var/www/html/

# Set proper permissions for WordPress
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]