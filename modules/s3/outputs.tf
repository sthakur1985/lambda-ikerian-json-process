output "raw_data_bucket_name" {
  value = aws_s3_bucket.raw_data.bucket
}

output "raw_data_bucket_arn" {
  value = aws_s3_bucket.raw_data.arn
}

output "processed_data_bucket_name" {
  value = aws_s3_bucket.processed_data.bucket
}

output "processed_data_bucket_arn" {
  value = aws_s3_bucket.processed_data.arn
}