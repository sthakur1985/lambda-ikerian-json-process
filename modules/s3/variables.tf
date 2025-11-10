variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "lambda_permission" {
  description = "Lambda permission resource for dependency"
}