bucket         = "ikerian-terraform-state-bucket"
key            = "prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "ikerian-terraform-locks"
encrypt        = true