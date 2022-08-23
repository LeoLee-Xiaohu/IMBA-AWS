terraform {
    backend "s3" {
      bucket         = "imba-terraform-state-backend"
      key            = "terraform.tfstate"
      region         = "ap-southeast-2"
      dynamodb_table = "terraform_state"
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

provider "aws" {}