variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  type        = string
}

variable "raw_bucket_arn" {
  description = "ARN of the raw data bucket"
  type        = string
}

variable "layer_arn" {
  description = "ARN of the Lambda layer"
  type        = string
  default     = null
}

variable "retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 60
}