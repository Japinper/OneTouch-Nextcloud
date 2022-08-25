#!/bin/bash

iphost=$(hostname -I)

figlet OneTouch-NXTC

echo "Creado por @Japinper y @ Layraaa"
echo ""

read -p "¿Deseas empezar con la instalación (Y-N)?--> " valor1

if [[ $valor1 == "Y" ]] || [[ $valor1 == "y" ]]
then
###Preguntas para creacion de DB (users and pssw)
	read -p "Introduce el nombre para la Base de Datos--> " dbname
	read -p "Introduce el nombre de usuario para la Base de Datos--> " dbuser
	read -p "Introduce una contraseña para el usuario $dbuser--> " pass
	sleep 1
	clear
###Ejecución de la instalación
	echo "[*] Preparando la instalación..."
	apt-get install -y sudo &> /dev/null
	apt-get install -y unzip &> /dev/null
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
	apt-get install -y mariadb-server mariadb-client &> /dev/null
	mysql -u root -p "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$pass'; CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost'; FLUSH PRIVILEGES; QUIT" &> /dev/null
	echo "Configuracion finalizada..."
	echo ""
	echo "Instalando Apache y PHP..."
	apt-get install -y php7.4 php-{cli,xml,zip,curl,gd,cgi,mysql,mbstring} &> /dev/null
        apt-get install -y apache2 libapache2-mod-php &> /dev/null
	sudo systemctl restart apache2
	echo "Instalacion Finalizada"
	echo""
	echo "Instalando Nextcloud..."
	apt-get install -y wget curl &> /dev/null
	wget https://download.nextcloud.com/server/releases/latest.zip &> /dev/null
	unzip latest.zip &> /dev/null
	rm -f latest.zip
	sudo mv nextcloud /var/www/html/
	sudo chown -R www-data:www-data /var/www/html/nextcloud
	sudo sudo chmod -R 755 /var/www/html/nextcloud
	sudo a2dissite 000-default.conf
	sudo rm /var/www/html/index.html
	sudo systemctl restart apache2 &> /dev/null
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
