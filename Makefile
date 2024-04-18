SHELL := /bin/bash
SITES_LIST=www www__about www__education www__research www__innovation www2018
include .env


.PHONY: help
# Print this help (see <https://gist.github.com/klmr/575726c7e05d8780505a> for explanation)
help:
	@echo "$$(tput bold)Available rules (alphabetical order):$$(tput sgr0)";sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## //;td" -e"s/:.*//;G;s/\\n## /---/;s/\\n/ /g;p;}" ${MAKEFILE_LIST}|LC_ALL='C' sort -f |awk -F --- -v n=$$(tput cols) -v i=20 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"%s%*s%s ",a,-i,$$1,z;m=split($$2,w," ");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;printf"\n%*s ",-i," ";}printf"%s ",w[j];}printf"\n";}'



## Coucou, je suis la doc de la target EC2
EC2:
    $(eval instance_id := $(shell aws ec2 run-instances \
		--region eu-central-2 \
		--image-id ami-0012c4a50d44fc78a \
		--count 1 \
		--instance-type t3.micro \
		--key-name "epflWP" \
		--security-group-ids sg-0f49502b10d5c3ec0 sg-03c3d5996d33bbff0 \
		--subnet-id subnet-0b627edec6cc82546 \
		--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="EWS2AWSv1"}]' \
		--user-data file://Prerequis_installation.txt | awk '/InstanceId/{print $2}') | sed 's/InstanceId: \([^,]*\),/\1/')
        @echo instance_id=$(instance_id) >>.env
        @echo L'instance est crée avec l'id $(instance_id)

IP_Static:
	$(eval allocation-id := $(shell aws ec2 allocate-address \
	    --region eu-central-2 \
	    --domain vpc-0d8ad0bf75015308c | awk '/allocation-id/{print $2}') | sed 's/allocation-id: \([^,]*\),/\1/')
	    @echo instance_id=$(allocation-id) >>.env
	    @echo L'instance est crée avec l'id $(allocation-id)

associate-IP:
	aws ec2 associate-address \
    --region eu-central-2 \
    --instance-id $(instance_id) \
    --allocation-id eipalloc-0887dd86e6eabd00a


Creation_DB:
	aws rds create-db-instance \
  	--db-instance-identifier dbEWS2AWS \
  	--db-instance-class db.t3.micro \
  	--engine MariaDB \
  	--master-username admin \
  	--master-user-password 12345678 \
  	--region eu-central-2 \
  	--vpc-security-group-ids sg-0f49502b10d5c3ec0 sg-05f915ac5b05eae54 \
	--allocated-storage 20 

	sudo mkdir -p /var/www/aws.fsd.team
		sudo mkdir -p /var/www/www2018.epfl.ch

		sudo chmod -R 755 /var/www
		vi /var/www/aws.fsd.team/index.html > 


	mysql -h dbews2aws.czkaoeksq1g8.eu-central-2.rds.amazonaws.com -P 3306 -u admin -p

	
Restor_backup_local:
	export AWS_SECRET_ACCESS_KEY=$(cat /keybase/team/epfl_wp_prod/aws-cli-credentials | grep -A2 '\[backup-wwp\]' | grep aws_secret_access_key | sed 's/aws_secret_access_key = //'); \
	export AWS_ACCESS_KEY_ID=$(cat /keybase/team/epfl_wp_prod/aws-cli-credentials | grep -A2 '\[backup-wwp\]' | grep aws_access_key_id | sed 's/aws_access_key_id = //'); \
	export RESTIC_PASSWORD=$(cat /keybase/team/epfl_wp_prod/aws-cli-credentials | grep -A3 '\[backup-wwp\]' | grep restic_password | sed 's/restic_password = //'); \

	for i in ${SITES_LIST}; do \
        mkdir -p /tmp/$${i}; \
        restic -r s3:https://s3.epfl.ch/svc0041-b80382f4fba20c6c1d9dc1bebefc5583/backup/wordpresses/$${i}/files restore latest --target /tmp/$${i}; \
        restic -r s3:https://s3.epfl.ch/svc0041-b80382f4fba20c6c1d9dc1bebefc5583/backup/wordpresses/$${i}/sql restore latest --target /tmp/$${i}; \
    done








