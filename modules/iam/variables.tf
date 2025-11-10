variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "raw_bucket_arn" {
  description = "ARN of the raw data bucket"
  type        = string
}

variable "processed_bucket_arn" {
  description = "ARN of the processed data bucket"
  type        = string
}