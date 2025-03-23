terraform {
  required_providers {
    aws = {
      source = "opentofu/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  # Configuration options
	region = "us-east-1"
}
