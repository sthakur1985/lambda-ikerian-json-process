# need unique bucket names
resource "random_string" "bucket_suffix" {
  length = 8
  special = false
  upper = false
}

# raw data bucket
resource "aws_s3_bucket" "raw_data" {
  bucket = "${var.project_name}-raw-data-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_versioning" "raw_data_versioning" {
  bucket = aws_s3_bucket.raw_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# processed data bucket  
resource "aws_s3_bucket" "processed_data" {
  bucket = "${var.project_name}-processed-data-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_versioning" "processed_data_versioning" {
  bucket = aws_s3_bucket.processed_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# trigger lambda when json files are uploaded
resource "aws_s3_bucket_notification" "raw_data_notification" {
  bucket = aws_s3_bucket.raw_data.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events = ["s3:ObjectCreated:*"]
    filter_suffix = ".json"  # only json files
  }

  depends_on = [var.lambda_permission]
}