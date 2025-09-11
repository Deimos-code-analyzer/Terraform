resource "aws_instance" "web" {
    ami = "ami-04f59c565deeb2199"
    instance_type = "t3.medium"
    key_name = "ayushnv"

    user_data = file("./runner.sh")

    tags = {
        Name = "AyushViaTerraform"
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
