terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.35.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable ca_subject {
  type = map(string)
}

data "aws_partition" "current" {}
