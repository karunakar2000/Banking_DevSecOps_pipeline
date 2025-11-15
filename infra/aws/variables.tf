# infra/aws/variables.tf

variable "aws_access_key" {
  description = "AWS access key used by pipelines (optional if using env credentials)"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key used by pipelines (optional if using env credentials)"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region where resources are deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "IGW_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "public_subnet1_cidr" {
  description = "CIDR for public subnet 1"
  type        = string
}

variable "public_subnet2_cidr" {
  description = "CIDR for public subnet 2"
  type        = string
}

variable "public_subnet3_cidr" {
  description = "CIDR for public subnet 3"
  type        = string
}

variable "public_subnet1_name" {
  description = "Name tag for public subnet 1"
  type        = string
}

variable "public_subnet2_name" {
  description = "Name tag for public subnet 2"
  type        = string
}

variable "public_subnet3_name" {
  description = "Name tag for public subnet 3"
  type        = string
}

variable "Main_Routing_Table" {
  description = "Name tag for the main public route table"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "environment" {
  description = "Environment identifier (DEV / UAT / PROD)"
  type        = string
}

variable "instance_type_map" {
  description = "Instance types per environment"
  type = map(string)
  default = {
    DEV  = "t2.micro"
    UAT  = "t2.micro"
    PROD = "t2.medium"
  }
}

# Optional: additional tags (e.g. owner, cost center)
variable "owner" {
  description = "Default Owner tag"
  type        = string
  default     = "DTB-Bank"
}

variable "cost_center" {
  description = "Default CostCenter tag"
  type        = string
  default     = "BANKING-PLATFORM"
}

 # Optional assume role ARN when using multi-account (used by provider-assumerole.tf)
variable "assume_role_arn" {
  description = "IAM Role ARN to assume for this Terraform execution (multi-account setup)"
  type        = string
  default     = ""
}
