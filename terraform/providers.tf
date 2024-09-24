terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
  }
}
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  alias  = "us-east-1"
  region = "us-east-1"
}