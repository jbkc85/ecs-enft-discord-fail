provider "aws" {
  region  = "us-east-1"
  profile = "<your aws profile name>"
}

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket  = "salesbot"
    key     = "salesbot.tfstate"
    region  = "us-east-1"
    profile = "<your aws profile name>"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.69.0"
    }
  }
}