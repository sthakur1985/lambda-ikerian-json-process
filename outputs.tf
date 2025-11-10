output "raw_data_bucket_name" {
  description = "Name of raw data S3 bucket"
  value = module.s3.raw_data_bucket_name
}

output "processed_data_bucket_name" {
  description = "Name of processed data S3 bucket"
  value = module.s3.processed_data_bucket_name
}

output "lambda_function_name" {
  description = "Name of Lambda function"
  value = module.lambda.lambda_function_name
}

output "lambda_layer_arn" {
  description = "ARN of Lambda layer"
  value = module.layers.layer_arn
}

output "terraform_state_bucket" {
  description = "S3 bucket for terraform state"
  value = aws_s3_bucket.terraform_state.bucket
}

output "terraform_locks_table" {
  description = "DynamoDB table for terraform locks"
  value = aws_dynamodb_table.terraform_locks.name
}