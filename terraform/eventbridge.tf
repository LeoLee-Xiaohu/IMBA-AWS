resource "aws_cloudwatch_event_rule" "lambda" {
  name                = "call-lambda-function"
  description         = "Event rule to call lambda on schedule"
  schedule_expression = "cron(0 20 * * ? *)"
  is_enabled          = false
}

resource "aws_cloudwatch_event_target" "lambda" {
  arn  = aws_lambda_function.trigger_glue_job.arn
  rule = aws_cloudwatch_event_rule.lambda.id

}

