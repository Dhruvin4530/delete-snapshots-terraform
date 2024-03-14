# IAM role for lambda function
resource "aws_iam_role" "lambda_execution" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# IAM policy related to snapshots 
resource "aws_iam_role_policy" "lambda" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeSnapshots",
          "ec2:DeleteSnapshot"
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

# lambda function to delete the snapshots
resource "aws_lambda_function" "delete_snapshots" {
  filename      = "delete-snapshot.zip"
  function_name = "delete_old_snapshots"
  role          = aws_iam_role.lambda_execution.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
}

# Trigger the Lambda function periodically using CloudWatch Events
resource "aws_cloudwatch_event_rule" "every_day" {
  name                = "every-day"
  description         = "Trigger Lambda every day"
  schedule_expression = "cron(20 7 * * ? *)" 
}

# Trigger the Lambda function
resource "aws_cloudwatch_event_target" "trigger_lambda_daily" {
  rule = aws_cloudwatch_event_rule.every_day.name
  arn  = aws_lambda_function.delete_snapshots.arn
}

# allow to invoke the lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_call" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_snapshots.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_day.arn
}

# cloudwatch log group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/delete_old_snapshots"
  retention_in_days = 90 
}