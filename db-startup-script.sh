#!/bin/bash


quitter=1
retour=0
while [[ $quitter -ne 0 ]]
do
    echo -e "Menu :\n1- Installation des paquets\n2- Création des fichiers de configuration\n3- Création de conteneur\n0- Quitter"
    read choix1
    case $choix1 in
	1 )
#Installation
	sudo apt update
	sudo apt install postgresql postgresql-contrib wget -y > /dev/null 2> /dev/null
	echo "Installation en cours ..."
	;;
	2 )
#Fichier init-database
	echo -e "Importation du fichier init-database..."
    cd /tmp/
    sudo wget https://github.com/TristanJodry/Shopsphere/blob/main/init-database.sql
    echo -e "Initialisation de la base de donnée"
    sudo -u postgres psql -f /tmp/init-database.sql
    sudo systemctl restart postgresql
    echo -e "La base de donnée est prête"
	;;
	0 )
	quitter=0
	;;
	* )
	echo "Erreur dans la saisie"
	;;
	esac
done
