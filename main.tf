terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

module "layers" {
  source = "./modules/layers"
  project_name = var.project_name
}

module "iam" {
  source = "./modules/iam"
  project_name = var.project_name
  raw_bucket_arn = module.s3.raw_data_bucket_arn
  processed_bucket_arn = module.s3.processed_data_bucket_arn
}

module "lambda" {
  source = "./modules/lambda"
  project_name = var.project_name
  lambda_role_arn = module.iam.lambda_role_arn
  raw_bucket_arn = module.s3.raw_data_bucket_arn
  layer_arn = module.layers.layer_arn
}

module "s3" {
  source = "./modules/s3"
  project_name = var.project_name
  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_permission = module.lambda.lambda_permission
}