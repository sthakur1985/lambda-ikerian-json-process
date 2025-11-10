# Architecture Diagram

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              AWS Data Pipeline                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────┐    S3 Event    ┌──────────────────┐    ┌─────────────────┐ │
│  │   Raw Data      │   Notification  │   Lambda         │    │   Processed     │ │
│  │   S3 Bucket     │────────────────▶│   Function       │───▶│   Data Bucket   │ │
│  │                 │                 │                  │    │                 │ │
│  │ ikerian_sample  │                 │ - Extract fields │    │ processed_      │ │
│  │ .json           │                 │ - Transform data │    │ ikerian_sample  │ │
│  └─────────────────┘                 │ - Error handling │    │ .json           │ │
│           │                          └──────────────────┘    └─────────────────┘ │
│           │                                   │                        │         │
│           │                                   ▼                        │         │
│           │                          ┌──────────────────┐              │         │
│           │                          │   CloudWatch     │              │         │
│           └─────────────────────────▶│   Logs           │◀─────────────┘         │
│                                      │                  │                        │
│                                      │ - Execution logs │                        │
│                                      │ - Error tracking │                        │
│                                      │ - Debug info     │                        │
│                                      └──────────────────┘                        │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                              Security & Access                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────────────┐ │
│  │   IAM Role      │    │   IAM Policy     │    │   Resource Permissions      │ │
│  │                 │    │                  │    │                             │ │
│  │ Lambda          │───▶│ - S3 Read (Raw)  │───▶│ - Raw Bucket: GetObject     │ │
│  │ Execution       │    │ - S3 Write (Proc)│    │ - Processed: PutObject      │ │
│  │ Role            │    │ - CloudWatch     │    │ - CloudWatch: CreateLogs    │ │
│  └─────────────────┘    └──────────────────┘    └─────────────────────────────┘ │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow

```
1. Upload JSON File
   ┌─────────────┐
   │   User      │
   │   Uploads   │──┐
   │   File      │  │
   └─────────────┘  │
                    ▼
2. S3 Raw Bucket    ┌─────────────────┐
   ┌───────────────▶│   Raw Data      │
   │                │   S3 Bucket     │
   │                │                 │
   │                │ ikerian_sample  │
   │                │ .json           │
   │                └─────────────────┘
   │                         │
   │                         │ S3 Event Trigger
   │                         ▼
3. Lambda Processing ┌──────────────────┐
   │                 │   Lambda         │
   │                 │   Function       │
   │                 │                  │
   │                 │ 1. Read JSON     │
   │                 │ 2. Extract fields│
   │                 │ 3. Transform     │
   │                 │ 4. Log progress  │
   │                 └──────────────────┘
   │                         │
   │                         │ Write processed data
   │                         ▼
4. Processed Data    ┌─────────────────┐
   └─────────────────│   Processed     │
                     │   Data Bucket   │
                     │                 │
                     │ processed_      │
                     │ ikerian_sample  │
                     │ .json           │
                     └─────────────────┘
```

## Infrastructure Components

### Terraform Resources Created:
1. **aws_s3_bucket.raw_data** - Raw data storage
2. **aws_s3_bucket.processed_data** - Processed data storage
3. **aws_lambda_function.data_processor** - Data processing function
4. **aws_iam_role.lambda_role** - Lambda execution role
5. **aws_iam_policy.lambda_policy** - Permissions policy
6. **aws_cloudwatch_log_group.lambda_logs** - Logging configuration
7. **aws_s3_bucket_notification.raw_data_notification** - Event trigger

### Security Model:
- **Principle of Least Privilege**: Lambda only has necessary permissions
- **Resource-Specific Access**: Policies target specific bucket ARNs
- **Audit Trail**: All actions logged to CloudWatch

### Scalability Considerations:
- **Serverless**: Lambda scales automatically with demand
- **Event-Driven**: Processing triggered only when needed
- **Cost-Effective**: Pay-per-execution model