resource "aws_dynamodb_table" "user_table" {
  name         = "user_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  # Only key/index attributes are declared here. Non-key fields such as
  # first_name and last_name are written per-item and need no schema.
  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Name        = "UserTable"
    Environment = "Production"
  }
}
