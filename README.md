# AWS Data Pipeline - Ikerian Cloud Engineer Assessment

## Overview
This project implements an end-to-end AWS data pipeline that processes JSON patient data using S3, Lambda, and CloudWatch, all managed through Terraform infrastructure as code.

## Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   Raw Data      │    │   Lambda         │    │   Processed Data    │
│   S3 Bucket     │───▶│   Function       │───▶│   S3 Bucket         │
│                 │    │                  │    │                     │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
         │                       │                        │
         │                       ▼                        │
         │              ┌──────────────────┐              │
         │              │   CloudWatch     │              │
         └──────────────│   Logs           │◀─────────────┘
                        └──────────────────┘
```

## Components

### 1. S3 Buckets
- **Raw Data Bucket**: Stores original JSON files
- **Processed Data Bucket**: Stores processed JSON with extracted fields

### 2. Lambda Function
- **Runtime**: Python 3.9
- **Trigger**: S3 ObjectCreated events on .json files
- **Processing**: Extracts `patient_id` and `patient_name` fields
- **Output**: Saves processed data to processed bucket

### 3. IAM Role & Policies
- **Lambda Execution Role**: Allows Lambda to assume role
- **S3 Permissions**: Read from raw bucket, write to processed bucket
- **CloudWatch Permissions**: Create logs and log streams

### 4. CloudWatch Logs
- **Log Group**: `/aws/lambda/ikerian-data-pipeline-data-processor`
- **Retention**: 14 days
- **Purpose**: Debug and monitor Lambda execution

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed
- Bash shell (for deployment script)

## Deployment Instructions

### GitHub Actions (Recommended)
1. Fork this repository
2. Set AWS credentials in GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. Push to main branch - deployment runs automatically

### Local Deployment
```bash
# Run deployment script
chmod +x deploy.sh
./deploy.sh
```

### Manual Deployment
```bash
# Build layer
mkdir -p layers/python/lib/python3.9/site-packages
pip install -r layers/requirements.txt -t layers/python/lib/python3.9/site-packages

# Deploy infrastructure
terraform init
terraform plan
terraform apply

# Upload test data
aws s3 cp ikerian_sample.json s3://$(terraform output -raw raw_data_bucket_name)/
```

## File Structure
```
├── main.tf              # Main Terraform configuration
├── variables.tf         # Terraform variables
├── outputs.tf           # Terraform outputs
├── lambda_function.py   # Lambda function code
├── ikerian_sample.json  # Sample patient data
├── deploy.ps1          # Windows deployment script
├── deploy.sh           # Linux/Mac deployment script
├── cleanup.ps1         # Cleanup script
├── modules/            # Terraform modules
│   ├── s3/            # S3 buckets module
│   ├── lambda/        # Lambda function module
│   ├── iam/           # IAM roles module
│   └── README.md      # Module documentation
└── README.md          # This documentation
```

## Sample Data Format

### Input (Raw Data)
```json
[
  {
    "patient_id": "P001",
    "patient_name": "John Doe",
    "age": 35,
    "diagnosis": "Hypertension",
    "admission_date": "2024-01-15",
    "doctor": "Dr. Smith",
    "department": "Cardiology"
  }
]
```

### Output (Processed Data)
```json
[
  {
    "patient_id": "P001",
    "patient_name": "John Doe"
  }
]
```

## Monitoring and Debugging
1. **CloudWatch Logs**: Check `/aws/lambda/ikerian-data-pipeline-data-processor`
2. **S3 Events**: Monitor bucket notifications in S3 console
3. **Lambda Metrics**: View execution metrics in Lambda console

## Approach and Design Decisions

### 1. Modular Architecture with for_each
- **Choice**: Terraform modules with for_each for multi-environment deployment
- **Rationale**: Single configuration manages multiple environments (dev, prod)
- **Structure**: Pipeline module orchestrates S3, Lambda, and IAM modules per environment

### 2. Infrastructure as Code
- **Choice**: Terraform for infrastructure management
- **Rationale**: Version control, reproducibility, and declarative configuration

### 2. Event-Driven Architecture
- **Choice**: S3 event triggers for Lambda
- **Rationale**: Automatic processing when new files are uploaded, serverless and cost-effective

### 3. Security Best Practices
- **Principle of Least Privilege**: IAM policies grant only necessary permissions
- **Resource Isolation**: Separate buckets for raw and processed data
- **Logging**: Comprehensive CloudWatch logging for audit and debugging

### 4. Error Handling
- **Lambda**: Try-catch blocks with detailed error logging
- **S3**: Versioning enabled for data recovery
- **CloudWatch**: Structured logging for troubleshooting

## Assumptions Made
1. **Data Format**: Input files are valid JSON arrays
2. **Required Fields**: All records contain `patient_id` and `patient_name`
3. **File Size**: Files are small enough for Lambda memory limits
4. **Region**: Default deployment to us-east-1
5. **Naming**: Unique bucket names using random suffixes

## Challenges Faced and Solutions

### 1. S3 Bucket Naming Conflicts
- **Challenge**: S3 bucket names must be globally unique
- **Solution**: Added random suffix to bucket names

### 2. Lambda Permissions
- **Challenge**: Complex IAM permissions for S3 and CloudWatch
- **Solution**: Separate IAM policy with specific resource ARNs

### 3. S3 Event Configuration
- **Challenge**: Circular dependency between S3 notification and Lambda
- **Solution**: Used `depends_on` in Terraform to manage resource creation order

## Cleanup
To destroy all resources:
```bash
terraform destroy
```

## Cost Optimization
- **Lambda**: Pay-per-execution model
- **S3**: Standard storage class for infrequent access
- **CloudWatch**: 14-day log retention to minimize costs

## Future Enhancements
1. **Data Validation**: Add schema validation for input JSON
2. **Error Handling**: Dead letter queue for failed processing
3. **Monitoring**: CloudWatch alarms for failures
4. **Scaling**: SQS for high-volume processing
5. **Security**: S3 bucket encryption and VPC endpoints