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
