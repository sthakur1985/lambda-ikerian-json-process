# Create a dummy file if layers directory is empty
resource "local_file" "dummy_layer" {
  content  = "# Dummy file for layer\n"
  filename = "${path.root}/layers/python/lib/python3.9/site-packages/dummy.py"
}

data "archive_file" "layer_zip" {
  type        = "zip"
  source_dir  = "${path.root}/layers/python"
  output_path = "${path.root}/lambda_layer.zip"
  
  depends_on = [local_file.dummy_layer]
}

resource "aws_lambda_layer_version" "dependencies" {
  filename         = data.archive_file.layer_zip.output_path
  layer_name       = "${var.project_name}-dependencies"
  source_code_hash = data.archive_file.layer_zip.output_base64sha256

  compatible_runtimes = ["python3.9"]
  description         = "Dependencies layer for ${var.project_name}"
}