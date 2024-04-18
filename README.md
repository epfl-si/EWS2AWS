# EWS2AWS

# Objectif 
Le but de mon TPI est de mettre en place un Proof of Concept (POC) visant à démontrer la faisabilité de créer une infrastructure cloud AWS et d’y restaurer une partie des sites Internet de l’EPFL. Cette opération doit être scriptée, permettant de limiter les tâches manuelles au maximum.

Pour ce TPI, je simulerai que l’infrastructure OpenShift est hors ligne, qu’il n’est pas possible d’accéder aux documents présents sur les sites respectifs et à leurs bases de données. Je serai amené à me baser sur les dernières sauvegardes, accessibles sur l’infrastructure de stockage objet (S3) complètement séparée de celle des sites.


# Prérequis techniques 
-	Avoir AWS CLI installer
-	Avoir un compte GitHub
-	Avoir accès au repository WP-Dev et à fsd-team de l’EPFL
-	Avoir un compte chez AWS
-	Avoir une clé ssh public
-	Avoir accès à Keybase

# Procédure

 - Etape 1 : 
 Cloner le repository en local

 - Etape 2 :
 Aller dans le dossier ou il y a le Makefiles

 - Etape 3 :
 Lancé la commande "make EC2" pour pouvoir créer une instance EC2 sur AWS

 - Etape 4 :
 Lancer la commnade "make IP_Static" pour pouvoir créer une ip statique pour ensuite la lier a l'alias aws.fsd.team

 - Etape 5 :
 Lier l'instance a l'ip il faut fiare la commande "make associate-IP" 

 - Etape 6 :
 Il y a la création de la base de donné RDS a faire avec la commande suivante "make Creation_DB"

