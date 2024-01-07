terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    dotenv = {
      source  = "stacklet/dotenv"
      version = ">=0.0.2, <2.0.0"
    }
  }
}

data "dotenv" "environment" {}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.dotenv.environment["AWS_SECRET_ARN"]
}

provider "aws" {
  region  = "ap-southeast-1"
  access_key = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["AWS_ACCESS_KEY_ID"]
  secret_key = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["AWS_SECRET_ACCESS_KEY"]
}
