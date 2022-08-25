#!/bin/bash

iphost=$(hostname -I)

figlet OneTouch-NXTC

echo "Creado por @Japinper y @ Layraaa"
echo ""

read -p "¿Deseas empezar con la instalación (Y-N)?--> " valor1

if [[ $valor1 == "Y" ]] || [[ $valor1 == "y" ]]
then
###Preguntas para creacion de DB (users and pssw)
	read -p "Introduce una contraseña de acceso para MySQL--> " mysqluser
	read -p "Introduce el nombre para la Base de Datos--> " dbname
	read -p "Introduce el nombre de usuario para la Base de Datos-->" dbuser
	read -p "Introduce una contraseña para el usuario $dbuser-->" userpass
	sleep 1
	clear
###Ejecución de la instalación
	echo "[*] Preparando la instalación..."
	sleep 1
	echo ""
	echo "Actualizando el sistema..."
	apt-get update -y &> /dev/null
	apt-get full-upgrade -y	&> /dev/null
	echo "[*] Actualizaciones realizadas"
	sleep 0.5
	echo ""
###Instalar DB
	echo "Instalando y configurando la base de datos..."
	apt-get install -y mariadb-server mariadb-client
	mysql -e "UPDATE mysql.user SET Password = PASSWORD('$mysqluser') WHERE User = 'root'; FLUSH PRIVILEGES; CREATE DATABASE $dbname; USE $dbname; CREATE USER $dbuser IDENTIFIED BY '$userpass'; GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$userpass'; GRANT ALL privileges ON $dbname.* TO $dbuser@localhost; FLUSH PRIVILEGES;" &> /dev/null
	echo "Configuracion finalizada..."
	echo ""
	echo "Instalando Apache y PHP..."
	apt-get install -y php7.4 php-{cli,xml,zip,curl,gd,cgi,mysql,mbstring}
        apt-get install -y apache2 libapache2-mod-php
	sudo systemctl restart apache2
	echo "Instalacion Finalizada"
	echo""
	echo "Instalando Nextcloud..."
	sudo apt -y install wget curl unzip
	wget https://download.nextcloud.com/server/releases/latest.zip
	unzip latest.zip
	rm -f latest.zip
	sudo mv nextcloud /var/www/html/
	sudo chown -R www-data:www-data /var/www/html/nextcloud
	sudo sudo chmod -R 755 /var/www/html/nextcloud
	sudo a2dissite 000-default.conf
	sudo rm /var/www/html/index.html
	sudo systemctl restart apache2
	echo "Nextcloud a sido Instalado Correctamente"
exit

elif [[ $valor1 == "N" ]] || [[ $valor1 == "n" ]]
then
echo "Cancelando..."
sleep 1
exit

else
echo "incorrecto"
fi
