# Lambda Module

Creates Lambda function with CloudWatch logging and S3 permissions for data processing.

## Resources Created

- **Lambda Function**: Python 3.9 runtime for data processing
- **CloudWatch Log Group**: Centralized logging with configurable retention
- **Lambda Permission**: Allows S3 to invoke the function
- **Deployment Package**: Automatically zips function code

## Usage

```hcl
module "lambda" {
  source = "./modules/lambda"
  
  project_name     = "my-project"
  lambda_role_arn  = "arn:aws:iam::123456789012:role/lambda-role"
  raw_bucket_arn   = "arn:aws:s3:::raw-bucket"
  layer_arn        = "arn:aws:lambda:us-east-1:123456789012:layer:deps:1"  # optional
  retention_days   = 14
  timeout         = 60
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Project name for resource naming | string | - | yes |
| lambda_role_arn | ARN of Lambda execution role | string | - | yes |
| raw_bucket_arn | ARN of raw data S3 bucket | string | - | yes |
| layer_arn | ARN of Lambda layer for dependencies | string | null | no |
| retention_days | CloudWatch log retention in days | number | 14 | no |
| timeout | Function timeout in seconds | number | 60 | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda_function_name | Name of Lambda function |
| lambda_function_arn | ARN of Lambda function |
| lambda_permission | Lambda permission resource |
| cloudwatch_log_group | CloudWatch log group name |

## Function Details

- **Runtime**: Python 3.9
- **Handler**: `lambda_function.lambda_handler`
- **Memory**: Default (128 MB)
- **Architecture**: x86_64
- **Code Source**: `lambda_function.py` in project root

## Features

- **Automatic Packaging**: Code automatically zipped for deployment
- **Layer Support**: Optional Lambda layers for dependencies
- **Configurable Logging**: Adjustable log retention period
- **S3 Integration**: Pre-configured S3 invoke permissions