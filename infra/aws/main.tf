# infra/aws/main.tf
# DTB, AWS network & compute (VPC, subnets, IGW, route table, SG, EC2)

terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

// Provider is defined in provider-assumerole.tf

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = var.IGW_name
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = var.public_subnet1_name
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name        = var.public_subnet2_name
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet3_cidr
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true

  tags = {
    Name        = var.public_subnet3_name
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = var.Main_Routing_Table
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "allow_all" {
  name        = "dtb-bank-allow-all-${var.environment}"
  description = "Allow all inbound/outbound traffic (demo; tighten for production)"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dtb-allow-all-${var.environment}"
    Environment = var.environment
  }
}


locals {
  instance_type = lookup(var.instance_type_map, var.environment, "t2.xlarge")
}

resource "aws_instance" "web_1" {
  ami                         = "ami-0f9de6e2d2f067fca" # TODO: update to your preferred AMI
  instance_type               = local.instance_type
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "DTB-${var.environment}-Server-1"
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    AZ          = "${var.aws_region}a"
  }
}

resource "aws_instance" "web_2" {
  ami                         = "ami-0f9de6e2d2f067fca" # TODO: update to your preferred AMI
  instance_type               = local.instance_type
  subnet_id                   = aws_subnet.public_2.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "DTB-${var.environment}-Server-2"
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    AZ          = "${var.aws_region}b"
  }
}


# Outputs

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID for DTB Bank environment"
}

output "public_subnet_ids" {
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id, aws_subnet.public_3.id]
  description = "Public subnet IDs"
}

output "web_public_ips" {
  value       = [aws_instance.web_1.public_ip, aws_instance.web_2.public_ip]
  description = "Public IP addresses of web instances"
}
