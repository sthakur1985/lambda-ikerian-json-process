# AWS Data Pipeline - Ikerian Cloud Engineer Assessment

## Overview
This project implements an end-to-end AWS data pipeline that processes retina scan patient data using S3, Lambda, and CloudWatch, all managed through Terraform infrastructure as code. The pipeline extracts patient identification information from detailed retina scan records for downstream processing.

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
- **Runtime**: Python 3.12
- **Trigger**: S3 ObjectCreated events on .json files
- **Processing**: Extracts `patient_id` and `patient_name` from retina scan data
- **Output**: Saves simplified patient records to processed bucket

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
mkdir -p layers/python/lib/python3.12/site-packages
pip install -r layers/requirements.txt -t layers/python/lib/python3.12/site-packages

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
├── providers.tf         # AWS provider configuration
├── variables.tf         # Terraform variables
├── locals.tf           # Local values and naming
├── outputs.tf          # Terraform outputs
├── backend.tf          # Backend resources
├── lambda_function.py  # Lambda function code
├── ikerian_sample.json # Sample retina scan data
├── deploy.sh          # Deployment script
├── env/               # Environment configurations
│   ├── backend.hcl    # Dev backend config
│   └── prod-backend.hcl # Prod backend config
├── .github/workflows/ # GitHub Actions
│   └── deploy.yml     # CI/CD pipeline
├── layers/            # Lambda layers
│   ├── requirements.txt # Python dependencies
│   └── python/        # Layer packages
├── modules/           # Terraform modules
│   ├── s3/           # S3 buckets module
│   ├── lambda/       # Lambda function module
│   ├── iam/          # IAM roles module
│   ├── layers/       # Lambda layers module
│   └── README.md     # Module documentation
└── README.md         # This documentation
```

## Sample Data Format

### Input (Raw Data)
```json
[
  {
    "patient_id": "A12345",
    "patient_name": "Ikerian A",
    "scan_date": "2025-01-01",
    "retina_thickness_microns": 275,
    "optic_disc_cup_ratio": 0.4,
    "diagnosis": "normal"
  },
  {
    "patient_id": "B67890",
    "patient_name": "Ikerian B",
    "scan_date": "2025-02-15",
    "retina_thickness_microns": 305,
    "optic_disc_cup_ratio": 0.6,
    "diagnosis": "suspected glaucoma"
  }
]
```

### Output (Processed Data)
```json
[
  {
    "patient_id": "A12345",
    "patient_name": "Ikerian A"
  },
  {
    "patient_id": "B67890",
    "patient_name": "Ikerian B"
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