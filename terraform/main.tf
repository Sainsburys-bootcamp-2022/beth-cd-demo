terraform {
  backend "s3" {
    bucket         = "sainsburys-shared-terraform-state"
    dynamodb_table = "sainsburys-shared-terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
}

provider "aws" {
    
}
