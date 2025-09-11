terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "ayush-terraform-state-bucket-fa287291"   # existing or created bucket
    key            = "github-runner/terraform.tfstate" # path inside the bucket
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"          # table for state locking
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

variable "runner_token" {
  description = "GitHub Runner registration token"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

resource "aws_instance" "github_runner" {
  ami           = "ami-04f59c565deeb2199"
  instance_type = "t2.large"
  key_name      = "ayushnv"

  user_data = templatefile("./runner.sh", {
    RUNNER_TOKEN = var.runner_token
  })

  tags = {
    Name = "---ayush---"
  }
}
