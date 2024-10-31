terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 3.18" # Update this as needed
    }
  }
}

provider "aws" {
  region     = var.region # For Paris
  access_key = var.access_key
  secret_key = var.secret_key
}