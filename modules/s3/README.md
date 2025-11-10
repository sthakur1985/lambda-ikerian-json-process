# S3 Module

Creates S3 buckets for raw and processed data storage with optional Lambda event notifications.

## Resources Created

- **Raw Data Bucket**: Stores original JSON files
- **Processed Data Bucket**: Stores transformed data
- **Bucket Versioning**: Enabled on both buckets
- **Event Notification**: Triggers Lambda on .json file uploads (optional)

## Usage

```hcl
module "s3" {
  source = "./modules/s3"
  
  project_name        = "my-project"
  lambda_function_arn = aws_lambda_function.processor.arn  # optional
  lambda_permission   = aws_lambda_permission.s3_invoke   # optional
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Project name for bucket naming | string | - | yes |
| lambda_function_arn | Lambda ARN for S3 notifications | string | null | no |
| lambda_permission | Lambda permission dependency | any | null | no |

## Outputs

| Name | Description |
|------|-------------|
| raw_data_bucket_name | Name of raw data bucket |
| raw_data_bucket_arn | ARN of raw data bucket |
| processed_data_bucket_name | Name of processed data bucket |
| processed_data_bucket_arn | ARN of processed data bucket |

## Features

- **Unique Naming**: Random suffix prevents naming conflicts
- **Versioning**: Protects against accidental deletions
- **Event Filtering**: Only triggers on .json files
- **Conditional Notification**: Creates notification only if Lambda ARN provided