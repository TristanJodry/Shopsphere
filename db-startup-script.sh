#!/bin/bash


quitter=1
retour=0
while [[ $quitter -ne 0 ]]
do
    echo -e "Menu :\n1- Installation des paquets\n2- Création des fichiers de configuration\n3- Resoudre problème de DB\n0- Quitter"
    read choix1
    case $choix1 in
	1 )
#Installation
	sudo apt update
    echo "Installation en cours ..."
	sudo apt install postgresql postgresql-contrib wget -y
	echo "Installation terminé"
	;;
	2 )
#Fichier init-database
	echo -e "Importation du fichier init-database..."
    cd /tmp/
    sudo wget https://github.com/TristanJodry/Shopsphere/raw/main/init-database.sql
    echo -e "Initialisation de la base de donnée"
    sudo -u postgres psql -f /tmp/init-database.sql
    sudo systemctl restart postgresql
    echo -e "La base de donnée est prête"
	;;
    3 )
    sudo bash -c 'PG_VERSION=$(ls /etc/postgresql/ | head -n1) && \
  PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf" && \
  PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf" && \
  echo "Configuring PostgreSQL $PG_VERSION..." && \
  sed -i "s/^listen_addresses.*/#listen_addresses = '\''localhost'\''/" "$PG_CONF" && \
  sed -i "s/#listen_addresses = '\''localhost'\''/listen_addresses = '\''*'\''/" "$PG_CONF" && \
  echo "host    all    all    10.0.0.0/8    md5" >> "$PG_HBA" && \
  systemctl restart postgresql && \
  echo "Done! PostgreSQL is now listening on all interfaces." && \
  netstat -tlnp | grep 5432'
    ;;
	0 )
	quitter=0
	;;
	* )
	echo "Erreur dans la saisie"
	;;
	esac
done
