# EWS2AWS

# Projet 
Le but de se projet est de mettre en place un POC1 permettant de démontrer la faisabilité d’une opération de “Cloud-Bursting”, c'est-à-dire de créer une infrastructure cloud AWS et d’y restaurer une partie des sites Internet de l’EPFL. Cette opération doit être scriptée (“as code”), permettant de limiter les opérations manuelles au maximum.
Pour ce POC, nous supposons que l’infrastructure OpenShift est en hors ligne : il n’est pas possible d’accéder aux documents présents sur les sites respectifs et/ou à leurs bases de données. Le candidat devra se baser sur les dernières sauvegardes, accessibles dans une infrastructure de stockage objects (S3) complètement séparée de celle des sites.


# Prérequis techniques 
-	Avoir AWS CLI installé
-	Avoir un compte GitHub
-	Avoir accès au repository WP-Dev et à fsd-team de l’EPFL
-	Avoir un compte chez AWS
-	Avoir une clé SSH public
-	Avoir accès à Keybase
-	Avoir Docker 

# Procédure
Voici les étapes à faire pour resoter des sites sur AWS

 - Git clone 
 - make create_EC2
 - make create_DB
 - création make create_static_IP plus 
 - Faire les modifications dans le repository fsd.team
 - make associate_static_IP
 - make download_from_restic prend quelque minute 
 - make update_wpconfig
 - make update_htaccess
 - make update_sql_dump
 - make create_db_users
 - démarer docker avant de lancé la suite des commandes 
 - make copy_wp_from_wp-dev
 - make copy_files
 - make import_db


 

