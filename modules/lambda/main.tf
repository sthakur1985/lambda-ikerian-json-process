# cloudwatch logs first
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/${var.project_name}-data-processor"
  retention_in_days = var.retention_days
}

# zip up the lambda code
data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "${path.root}/lambda_function.py"
  output_path = "${path.root}/lambda_function.zip"
}

# main lambda function
resource "aws_lambda_function" "data_processor" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "${var.project_name}-data-processor"
  role = var.lambda_role_arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
  timeout = var.timeout
  
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  # add layer if we have one
  layers = var.layer_arn != null ? [var.layer_arn] : []
  
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
}

resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.raw_bucket_arn
}