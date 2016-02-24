FROM iant/lamp:latest
MAINTAINER Ian Truslove <ian.truslove@gmail.com>

# Install plugins
RUN apt-get update && \
  apt-get -y install php5-gd php5-curl && \
  rm -rf /var/lib/apt/lists/*

# Download latest version of Wordpress into /app
RUN rm -fr /app && git clone --depth=1 https://github.com/WordPress/WordPress.git /app

# Configure Wordpress to connect to local DB
ADD wp-config.php /app/wp-config.php
ADD .htaccess /var/www/html/.htaccess

# Modify permissions to allow plugin upload
RUN chown -R www-data:www-data /app/wp-content /var/www/html
RUN chmod u+w /var/www/html/.htaccess

# Add database setup script
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD create_db.sh /create_db.sh
RUN chmod +x /*.sh

VOLUME ["/app/wp-content" "/var/www/html"]

EXPOSE 80 3306
CMD ["/run.sh"]
