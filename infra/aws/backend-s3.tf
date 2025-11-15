// infra/aws/backend-s3.tf
// Remote backend for DTB Bank AWS infrastructure state

terraform {
  backend "s3" {
    bucket         = "dtb-bank-aws-tfstate"        
    key            = "network/terraform.tfstate"   
    region         = "us-east-1"                   
    dynamodb_table = "dtb-bank-tf-locks"           
    encrypt        = true
  }
}
