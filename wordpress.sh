#!/bin/bash

ipbd1="${IPBD}"
#Instalação de pacotes
sudo apt -y update
sudo apt -y install php-curl php-gd php-mbstring php-xml php-xmlrpc apache2 php libapache2-mod-php php-mysql
#Modificação do arquivo conf do apache e habilitando o mesmo.
sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/apache2/apache2.conf
sudo a2dissite 000-default.conf
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service

#Pegando o wordpress mais atualizado
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
sudo mv wordpress /var/www/html/wordpress
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/

cat <<EOF > /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
   ServerAdmin admin@example.com
   DocumentRoot /var/www/html/wordpress/
   ServerName example.com
   ServerAlias www.example.com
   <Directory /var/www/html/wordpress/> 
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
   </Directory>
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined 
</VirtualHost>
EOF

#Reiniciando os serviços
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
#Conexão do banco
sudo mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/wordpress/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/wordadm/g" /var/www/html/wordpress/wp-config.php 
sudo sed -i "s/password_here/wordpress/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/localhost/$ipbd1/g" /var/www/html/wordpress/wp-config.php
