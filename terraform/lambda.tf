### lambda function triggered by eventbridge 

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_glue_job.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda.arn
}

resource "aws_lambda_function" "trigger_glue_job" {

  # filename      = "arn:aws:s3:::imba-aws-source-code/lambda/trigger_glue_job.py.zip"
  filename      = "../scripts/lambda/trigger_glue_job.py.zip"
  function_name = "trigger-glue-job"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
}


## lambda function triggered by S3 bucket 


resource "aws_lambda_permission" "allow_bucket1" {
  statement_id  = "AllowExecutionFromS3Bucket1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_glue_job_4_features.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.data_bucket.arn
}

resource "aws_lambda_function" "trigger_glue_job_4_features" {
  # filename      = "arn:aws:s3:::imba-aws-source-code/lambda/trigger_glue_job_4_features.py.zip"
  filename      = "../scripts/lambda/trigger_glue_job_4_features.py.zip"
  function_name = "trigger-glue-job-4-features"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
}


resource "aws_lambda_permission" "allow_bucket2" {
  statement_id  = "AllowExecutionFromS3Bucket2"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_glue_create_result.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.data_bucket.arn
}

resource "aws_lambda_function" "trigger_glue_create_result" {
  # filename      = "arn:aws:s3:::imba-aws-source-code/lambda/trigger_glue_job_create_result_csv.py.zip"
  filename      = "../scripts/lambda/trigger_glue_create_result_csv.py.zip"
  function_name = "trigger-glue-create-result"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.data_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.trigger_glue_job_4_features.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "features/order_products_prior/"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.trigger_glue_create_result.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "features/prd_features_db/"
  }

  depends_on = [
    aws_lambda_permission.allow_bucket1,
    aws_lambda_permission.allow_bucket2
  ]
}