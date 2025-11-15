# infra/aws/prod.tfvars

aws_region          = "us-east-1"
vpc_cidr            = "172.16.0.0/16"
public_subnet1_cidr = "172.16.1.0/24"
public_subnet2_cidr = "172.16.2.0/24"
public_subnet3_cidr = "172.16.3.0/24"

vpc_name            = "DevSecOps-PROD-VPC"
IGW_name            = "DevSecOps-PROD-IGW"
public_subnet1_name = "DevSecOps-PROD-Subnet1"
public_subnet2_name = "DevSecOps-PROD-Subnet2"
public_subnet3_name = "DevSecOps-PROD-Subnet3"
Main_Routing_Table  = "DevSecOps-PROD-MAIN-RT"

key_name    = "dtb-key1"
environment = "PROD"

owner       = "DTB-Bank"
cost_center = "PROD-ENV"
