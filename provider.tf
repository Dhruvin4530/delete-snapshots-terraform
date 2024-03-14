# configure aws provider
provider "aws" {
  region  = var.region
}

# configure backend
terraform {
  backend "s3" {
    bucket         = "github-workflow-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock-dynamodb"
  }
}