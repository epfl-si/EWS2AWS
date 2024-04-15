EC2:
	aws ec2 run-instances \
		--region eu-central-2 \
		--image-id ami-0012c4a50d44fc78a \
		--count 1 \
		--instance-type t3.micro \
		--key-name "epflWP" \
		--security-group-ids sg-0f49502b10d5c3ec0 \
		--subnet-id subnet-0b627edec6cc82546 \
		--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="EWS2AWSv1"}]' \
		--user-data file://Prerequis_installation.txt

IP_Static:
	aws ec2 allocate-address \
    --network-border-group eu-west-1 \
    --domain vpc-0ce906bb278c17130

associate-IP:
	aws ec2 associate-address --instance-id i-0f881579de087b4a0 --allocation-id eipalloc-059f1f34afc284a40


	


Creation_DB:
	aws rds create-db-instance \
  	--db-instance-identifier dbEWS2AWS \
  	--db-instance-class db.t3.micro \
  	--engine MariaDB \
  	--master-username admin \
  	--master-user-password 12345678 \
  	--region eu-central-2 \
  	--vpc-security-group-ids sg-0f49502b10d5c3ec0 \
	--allocated-storage 20 