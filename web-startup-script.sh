#!/bin/bash


quitter=1
retour=0
while [[ $quitter -ne 0 ]]
do
    echo -e "Menu :\n1- Installation des paquets\n2- Création des fichiers de configuration\n0- Quitter"
    read choix1
    case $choix1 in
	1 )
#Installation
	sudo apt update
	sudo apt install postgresql-client nodejs wget npm -y > /dev/null 2> /dev/null
	echo "Installation en cours ..."
	;;
	2 )
#Fichier de conf pour shopsphere
    echo -e "Quelle est l'ip de votre VM DB ?"
    read ipdb
	echo -e "Importation du dossier shopsphere..."
    sudo printf '[Unit]\nDescription=ShopSphere Node.js Application\nAfter=network.target\n\n[Service]\nType=simple\nUser=root\nWorkingDirectory=/opt/shopsphere\nExecStart=/usr/bin/node server.js\nRestart=always\nRestartSec=10\nStandardOutput=journal\nStandardError=journal\nSyslogIdentifier=shopsphere\nEnvironment=NODE_ENV=production\nEnvironment=PORT=80\nEnvironment=DB_HOST='$ipdb'\nEnvironment=DB_USER=shopsphere_user\nEnvironment=DB_PASSWORD="ShopSphere2024!"\nEnvironment=DB_NAME=shopsphere\nEnvironment=DB_PORT=5432\n\n[Install]\nWantedBy=multi-user.target' > ~/shopsphere.service
    sudo mv ~/shopsphere.service /etc/systemd/system/
    cd /opt/
    sudo wget https://github.com/TristanJodry/Shopsphere/blob/main/shopsphere.tar.gz
    sudo tar -xvzf /opt/shopsphere.tar.gz
    sudo mv -f /opt/opt/shopsphere/ /opt/
    sudo rm -r /opt/opt/
    cd /opt/shopsphere
    sudo npm install
    sudo systemctl daemon-reload
    sudo systemctl enable shopsphere
    sudo systemctl start shopsphere
    echo -e "Le site est Shopsphere est disponible"
	;;
	0 )
	quitter=0
	;;
	* )
	echo "Erreur dans la saisie"
	;;
	esac
done