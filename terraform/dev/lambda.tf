# Infrastructure for software layer server (lambda)

data "archive_file" "http-lambda-zip" {
  type        = "zip"
  output_path = "../../http-lambda.zip"
  source_file = "../../src/lambda_function.py"
}

# Permissions for APIGW to trigger lambda
resource "aws_lambda_permission" "apigw-http-lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http-lambda-function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.api.id}/*/*/${aws_api_gateway_resource.resource.path_part}"
}

resource "aws_lambda_function" "http-lambda-function" {
  filename         = data.archive_file.http-lambda-zip.output_path
  source_code_hash = data.archive_file.http-lambda-zip.output_base64sha256
  function_name    = "smart-test-http-lambda"
  role             = aws_iam_role.http-lambda-role.arn
  handler          = "lambda_get_function.lambda_handler"
  runtime          = "python3.7"
}

resource "aws_iam_role" "http-lambda-role" {
  name = "smart-test-http-lambda-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# Allow lambda to access dynamodb
resource "aws_iam_policy" "lambda-dynamodb-policy" {
  name        = "smart-test-http-lambda-dynamodb-policy"
  description = "Policy for smart-test-http-lambda role to manage smart-test-http dynamodb."
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:GetItem"
      ],
      "Resource": "${aws_dynamodb_table.http-db.arn}",
      "Effect": "Allow",
      "Sid": "AllowReadDynamoDb"
    }
  ]
}
POLICY
}

resource "aws_cloudwatch_log_group" "http-lambda-cloudwatch-log-group" {
  name              = "/aws/lambda/${aws_lambda_function.http-lambda-function.function_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "http-lambda-logging" {
  name        = "smart-test-http-lambda-logging-policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow",
      "Sid" : "AllowCloudwatchLogging"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "http-lambda-logs-policy-attach" {
  role       = aws_iam_role.http-lambda-role.name
  policy_arn = aws_iam_policy.http-lambda-logging.arn
}

resource "aws_iam_role_policy_attachment" "http-lambda-dynamodb-policy-attach" {
  role       = aws_iam_role.http-lambda-role.name
  policy_arn = aws_iam_policy.lambda-dynamodb-policy.arn
}
