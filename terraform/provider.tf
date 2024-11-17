terraform {
  backend "s3" {
    bucket = "terraform-tfstate-stockage"
    key = "key/preproduction/terraform.tfstate"
    region = "eu-west-3"
  }
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = " 5.60.0"  #last version
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
