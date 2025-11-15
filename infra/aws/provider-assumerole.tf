 # infra/aws/provider-assumerole.tf
// AWS provider with optional AssumeRole support for multi-account setups.

provider "aws" {
  region = var.aws_region

  # If assume_role_arn is set (non-empty), Terraform will assume that role.
  dynamic "assume_role" {
    for_each = var.assume_role_arn != "" ? [var.assume_role_arn] : []
    content {
      role_arn = assume_role.value
    }
  }
}
