terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
  backend "s3" {
    bucket = "80sivbucket"
    key = "path/to/my/key"  # you should have unique keys with in the bucket, same key should not not be used in other repos.
    region = "ap-south-1"
    dynamodb_table = "80siv-state-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}