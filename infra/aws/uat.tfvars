# infra/aws/uat.tfvars

aws_region          = "us-east-1"
vpc_cidr            = "192.168.0.0/16"
public_subnet1_cidr = "192.168.1.0/24"
public_subnet2_cidr = "192.168.2.0/24"
public_subnet3_cidr = "192.168.3.0/24"

vpc_name            = "DevSecOps-UAT-VPC"
IGW_name            = "DevSecOps-UAT-IGW"
public_subnet1_name = "DevSecOps-UAT-Subnet1"
public_subnet2_name = "DevSecOps-UAT-Subnet2"
public_subnet3_name = "DevSecOps-UAT-Subnet3"
Main_Routing_Table  = "DevSecOps-UAT-MAIN-RT"

key_name    = "dtb-key1"
environment = "UAT"

owner       = "DTB-Bank"
cost_center = "UAT-ENV"
