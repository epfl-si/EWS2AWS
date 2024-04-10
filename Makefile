EC2:
	aws ec2 run-instances \
		--region eu-west-1 \
		--image-id ami-0d940f23d527c3ab1 \
		--count 1 \
		--instance-type t2.micro \
		--key-name "Default_Key" \
		--security-group-ids sg-0957192a8dd9b85d5 \
		--subnet-id subnet-068a85fca33f6410d \
		--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="EWS2AWSv1"}]' \
		--user-data file://Prerequis_installation.txt
