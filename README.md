# Moveo Homework Assignment 

### This project was done as a part of my application process to moveo.
### This project aims to levrege terraform and docker to create an inferstrcture that sets up a secure custom ngnix container on an ec2 instance 

# Please keep in mind 
the ec2 instance is protected by an application load balancer that only accepts https trafic.
Please keep in mind that this project does not include the registration of the ACM certificate due to known issues with Terraform's handling of ACM certificate validation. You will need to manually request and validate the ACM certificate in the AWS Management Console and then reference the ARN of the validated certificate in the terraform.tfvars file. The main reason to do it is for security reasons,an ALB that uses https is much more secure. 

# To use the project first configure AWS CLI:
- ```aws configure```

# Clone the Repository:
- ```git clone https://github.com/talvinisky/Moveo-HA.git```
- ```cd Moveo-HA```

# Initialize Terraform:
initialize Terraform 
- ```Terraform init```

# Create terraform.tfvars File:
Create a terraform.tfvars file in the root directory and add the necessary variable values
aws_region = "eu-central-1"
domain_name = ""
zone_id = ""
instance_type = ""
ami_id = ""
key_name = ""
vpc_cidr = ""
public_subnet_cidrs = [""]
private_subnet_cidrs = [""]
certificate_arn = ""  
availability_zones = [""]

#Terraform Plan:
Use the plan command to see what is expected to be created by the configuration:
- ```Terraform plan```

#Terraform Apply:
once you checked everything is in order execute the apply command:
- ```Terraform Apply```

#Terraform Destroy:
To clean up the resources created by Terraform:
-```Terraform Destroy```






    
  
