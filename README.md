# EWS2AWS

# Projet

Le but de ce projet est de mettre en place un [POC] permettant de démontrer
la faisabilité d’une opération de “Cloud-Bursting”, c’est-à-dire de créer une
infrastructure cloud AWS et d’y restaurer une partie des sites Internet de
l’EPFL.

Cette opération doit être scriptée (“as code”), permettant de limiter les
opérations manuelles au maximum.

Le fichier [MakeFile](./Makefile) présent dans ce repository liste les
différentes actions nécessaires à la restauration d’une sélection de sites EPFL
vers AWS. Ces actions sont décrites ci-dessous.

## Prérequis techniques

Pour mener à bien les différentes actions définies dans le
[MakeFile](./Makefile), il est nécessaire d'avoir ces prérequis :

- Avoir intstallé [AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), pour intéragir avec l'API d'Amazon
- Avoir cloné le repository [epfl-si/wp-dev](https://github.com/epfl-si/wp-dev) et démarré l'environnement de développement afin de pouvoir récupérer le point de montage partagé des sites WordPress
- Avoir les droits de contribuer sur le repository [epfl-fsd/fsd-team](https://github.com/epfl-fsd/fsd.team) pour mettre à jour les entrées DNS du domaine https://fsd.team
- Avoir un compte chez [AWS](https://aws.amazon.com) afin de pouvoir créer les instances EC2 et RDS pour héberger les sites
- Posséder une clé SSH, afin de pouvoir se connecter aux instances sur AWS
- Avoir accès aux répertoires [Keybase](https://keybase.io/) /keybase/team/epfl_wp_prod contenant les secrets pour accéder aux backups


##  Procédure

Voici les étapes à suivre pour restaurer des sites sur AWS.

> [!TIP]
> La commande make help liste les différentes actions présentent dans le Makefile.

En premier lieu il faut créer un fichier .env dans le clone de ce repository
et y ajouter XXX.


La commande make create_EC2 permet de créer une instance EC2, équivalent d'une
machine virtuelle sur AWS. C'est cette instance qui hébergera le serveur web qui
servira les différents sites réstaurés.

Pour céer la base de données il faut lancé la commande make create_DB, qui permet de créer un serveur de base de données sur AWS. Qui nous permetrera de restaurer les bases de données de sites.

La commande make create_static_IP permet de créer une IP Statique donc une IP fixe pour pouvoir atteindre le serveur EC2 tout le temps. Cette commnade il faut l'exécuter qu'une fois.

Une fois l'IP créer il faut Cloner le repository [fsd.team](https://github.com/epfl-fsd/fsd.team/tree/master) pour aller modifier le fichier main.yml dans le répertoire roles/zoneDNS/tasks/main.yml. Il faut modifier se paragraphe la du code en remplaçons les IP par celle qui a été créer dans juste en haut : 
```
- name: Create the ”aws.fsd.team” record to 16.63.247.178
  community.general.gandi_livedns:
    domain: fsd.team
    record: aws
    type: A
    values:
      - 16.63.247.178
    ttl: 300
    api_key: "{{ fsdteam_secrets.gandiAPIkey }}"
  tags: 
    - aws
```

Une fois la modification fait il faut faire la commande  ./fsdteamsible -t aws pour que l'IP se lier avec l'alias.

La commande make associate_static_IP permet d'associer l'IP au serveur EC2 qui permetera au serveur d'avoir toujours la même IP même lors de la création d'une nouvelle instance.

La commande make download_from_restic permeteras de récupérer les backup des sites et leur bases de données en local pour ensuite les restaurers sur Amazone.

La commande make update_wpconfig effectue le changement du chemin du site et du db-host. En récuprent les informations dans des variables dans le script.

Les commande make update_htaccess make update_sql_dump vous tout deux changé les urls une foit dans le .htaccess et une fois dans les fichier de bases de donnés.

La commande make create_db_users vas récupérer les informations de wp-config.php pour avoir le user, le password et le nom de la base de donnés, pour pouvoir ensuite créer dans la DB, le user et la bases de donné.

Ensuite il faut démarer Docker pour pouvoir lancé la commande make copy_wp_from_wp-dev

La commande make copy_wp_from_wp-dev permet de récupérer le répertoire /wp qui se trouve dans wp-dev 

La commande make copy_files vas copier tout les fichiers que nous avons restaurer en local sur EC2 dans le répertoire /var/www/aws.fsd.team ou dans le repertoire www2018.epfl.ch

La dernier commande make import_db permet d'importer les bases de donné dans RDS pour que le site fonctionne 




[POC]: https://fr.wikipedia.org/wiki/Preuve_de_concept
