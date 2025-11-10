variable "aws_region" {
  description = "AWS region for resources"
  type = string
  default = "us-east-1"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type = string
  default = "ikerian-data-pipeline"
}

variable "environment" {
  description = "Environment name"
  type = string
  default = "dev"
}