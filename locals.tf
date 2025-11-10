locals {
  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "ikerian-team"
  }

  # Resource naming convention
  name_prefix = "${var.project_name}-${var.environment}"
  
  # S3 bucket names
  raw_bucket_name       = "${local.name_prefix}-raw-data"
  processed_bucket_name = "${local.name_prefix}-processed-data"
  
  # Lambda configuration
  lambda_function_name = "${local.name_prefix}-data-processor"
  lambda_timeout      = 60
  lambda_memory       = 128
  
  # CloudWatch log retention
  log_retention_days = var.environment == "prod" ? 30 : 7
}