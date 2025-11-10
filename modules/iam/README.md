# IAM Module

Creates IAM roles and policies for Lambda function execution with S3 and CloudWatch permissions.

## Resources Created

- **Lambda Execution Role**: Allows Lambda service to assume role
- **IAM Policy**: Grants S3 read/write and CloudWatch logging permissions
- **Policy Attachment**: Links policy to role

## Usage

```hcl
module "iam" {
  source = "./modules/iam"
  
  project_name         = "my-project"
  raw_bucket_arn      = "arn:aws:s3:::my-raw-bucket"
  processed_bucket_arn = "arn:aws:s3:::my-processed-bucket"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Project name for resource naming | string | - | yes |
| raw_bucket_arn | ARN of raw data S3 bucket | string | - | yes |
| processed_bucket_arn | ARN of processed data S3 bucket | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| lambda_role_arn | ARN of Lambda execution role |

## Permissions Granted

### CloudWatch Logs
- `logs:CreateLogGroup`
- `logs:CreateLogStream` 
- `logs:PutLogEvents`

### S3 Access
- `s3:GetObject` on raw bucket objects
- `s3:PutObject` on processed bucket objects

## Security Features

- **Least Privilege**: Only necessary permissions granted
- **Resource-Specific**: Policies target specific bucket ARNs
- **Service Principal**: Only Lambda service can assume role