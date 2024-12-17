resource "aws_dynamodb_table" "terraform_aws_db" {
    name         = var.aws_dynamodb_table_name
    billing_mode = var.aws_dynamodb_billing_mode
    hash_key     = var.aws_dynamodb_table_haskey

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        Name = var.aws_dynamodb_table_name
    }
}