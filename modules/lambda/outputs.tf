output "lambda_function_name" {
  value = aws_lambda_function.data_processor.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.data_processor.arn
}

output "lambda_permission" {
  value = aws_lambda_permission.s3_invoke
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.lambda_logs.name
}