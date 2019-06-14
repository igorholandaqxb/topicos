#!/bin/bash
#Instalando pacotes para o banco
sudo apt-get update
sudo apt-get -y install mysql-server
#Conf do banco WP.
sudo mysql <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wordadm'@'%' IDENTIFIED BY 'wordpress';
GRANT ALL ON wordpress.* TO 'wordadm'@'%';
FLUSH PRIVILEGES;
EOF
echo "Banco de dados criado com sucesso!"
