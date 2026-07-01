data "archive_file" "create_user_zip" {
  type        = "zip"
  source_file = "${path.module}/../backend/src/lambdas/create_user.js"
  output_path = "${path.module}/build/create_user.zip"
}

resource "aws_lambda_function" "create_user" {
  function_name = "create_user"
  role          = aws_iam_role.create_user_lambda.arn
  handler       = "create_user.handler"
  runtime       = "nodejs20.x"

  filename         = data.archive_file.create_user_zip.output_path
  source_code_hash = data.archive_file.create_user_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.user_table.name
    }
  }
}

data "archive_file" "pull_users_zip" {
  type        = "zip"
  source_file = "${path.module}/../backend/src/lambdas/pull_users.js"
  output_path = "${path.module}/build/pull_users.zip"
}

resource "aws_lambda_function" "pull_users" {
  function_name = "pull_users"
  role          = aws_iam_role.pull_users_lambda.arn
  handler       = "pull_users.handler"
  runtime       = "nodejs20.x"

  filename         = data.archive_file.pull_users_zip.output_path
  source_code_hash = data.archive_file.pull_users_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.user_table.name
    }
  }
}

# Public HTTPS endpoint the browser can fetch. No API Gateway needed.
resource "aws_lambda_function_url" "pull_users" {
  function_name      = aws_lambda_function.pull_users.function_name
  authorization_type = "NONE" # public — anyone with the URL can call it

  cors {
    allow_origins = ["*"]
    allow_methods = ["GET"]
  }
}

# Public HTTPS endpoint so the browser can POST a new user.
resource "aws_lambda_function_url" "create_user" {
  function_name      = aws_lambda_function.create_user.function_name
  authorization_type = "NONE" # public — anyone with the URL can call it

  cors {
    allow_origins = ["*"]
    allow_methods = ["POST"]
    allow_headers = ["content-type"]
  }
}
