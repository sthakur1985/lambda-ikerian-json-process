# Terraform Modules

This directory contains reusable Terraform modules for the AWS Data Pipeline.

## Module Structure

### S3 Module (`./s3/`)
- **Purpose**: Creates S3 buckets for raw and processed data
- **Resources**: 
  - Raw data bucket with versioning
  - Processed data bucket with versioning
  - S3 event notification for Lambda trigger
- **Outputs**: Bucket names and ARNs

### IAM Module (`./iam/`)
- **Purpose**: Creates IAM roles and policies for Lambda
- **Resources**:
  - Lambda execution role
  - IAM policy with S3 and CloudWatch permissions
  - Policy attachment
- **Outputs**: Lambda role ARN

### Lambda Module (`./lambda/`)
- **Purpose**: Creates Lambda function and CloudWatch logs
- **Resources**:
  - Lambda function with Python runtime
  - CloudWatch log group
  - Lambda permission for S3 invocation
- **Outputs**: Function name, ARN, and log group

### Layers Module (`./layers/`)
- **Purpose**: Creates Lambda layers for dependencies
- **Resources**:
  - Lambda layer with Python packages
- **Outputs**: Layer ARN

## Module Dependencies

```
Layers Module ──┐
                ├──▶ Lambda Module ──▶ S3 Module
IAM Module ─────┤
                └──▶ (provides dependencies & role)
```

## Usage

Modules are automatically called from the root `main.tf` with proper dependency management.

## Individual Module Documentation

- [S3 Module](./s3/README.md) - S3 buckets and event notifications
- [IAM Module](./iam/README.md) - IAM roles and policies
- [Lambda Module](./lambda/README.md) - Lambda function and CloudWatch logs
- [Layers Module](./layers/README.md) - Lambda layers for dependencies
- [Pipeline Module](./pipeline/README.md) - Complete pipeline orchestration

## Quick Reference

| Module | Purpose | Key Resources |
|--------|---------|---------------|
| S3 | Data storage | Raw/processed buckets, notifications |
| IAM | Access control | Lambda execution role, policies |
| Lambda | Data processing | Function, CloudWatch logs |
| Layers | Dependencies | Python packages layer |
| Pipeline | Orchestration | Complete pipeline per environment |