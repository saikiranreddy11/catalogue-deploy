terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }

  backend "s3"{
    bucket = "robo-bucket-dev"
    key = "catalogue-dev"
    region = "us-east-1"
    dynamodb_table = "roboshop-lock"
  }
}

provider "aws" {
  # Configuration options
   region = "us-east-1"
}