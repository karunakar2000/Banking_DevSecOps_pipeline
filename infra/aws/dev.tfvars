# infra/aws/dev.tfvars

aws_region          = "us-east-1"
vpc_cidr            = "10.1.0.0/16"
public_subnet1_cidr = "10.1.1.0/24"
public_subnet2_cidr = "10.1.2.0/24"
public_subnet3_cidr = "10.1.3.0/24"

vpc_name            = "DevSecOps-DEV-VPC"
IGW_name            = "DevSecOps-DEV-IGW"
public_subnet1_name = "DevSecOps-DEV-Subnet1"
public_subnet2_name = "DevSecOps-DEV-Subnet2"
public_subnet3_name = "DevSecOps-DEV-Subnet3"
Main_Routing_Table  = "DevSecOps-DEV-MAIN-RT"

key_name    = "dtb-key1"
environment = "DEV"

owner       = "DTB-Bank"
cost_center = "DEV-ENV"
