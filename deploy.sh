#!/bin/bash

# Simple deployment script
ENV=${1:-dev}

echo "Deploying to $ENV environment..."

# Build layer
echo "Building layer..."
mkdir -p layers/python/lib/python3.12/site-packages
pip install -r layers/requirements.txt -t layers/python/lib/python3.12/site-packages --no-deps

# Use appropriate backend config
if [ "$ENV" = "prod" ]; then
  BACKEND_CONFIG="env/prod-backend.hcl"
else
  BACKEND_CONFIG="env/backend.hcl"
fi

echo "Using backend config: $BACKEND_CONFIG"
terraform init -backend-config=$BACKEND_CONFIG
terraform plan -var="environment=$ENV"
terraform apply -var="environment=$ENV" -auto-approve

echo "Uploading test data..."
BUCKET=$(terraform output -raw raw_data_bucket_name)
aws s3 cp ikerian_sample.json s3://$BUCKET/

echo "Deployment complete!"