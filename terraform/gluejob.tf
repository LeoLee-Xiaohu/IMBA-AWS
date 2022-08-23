resource "aws_glue_job" "job1" {
  name         = "create_prior_parquet"
  role_arn     = aws_iam_role.glue_job_role.arn
  glue_version = "3.0"

  command {
    script_location = "s3://${aws_s3_bucket.source_code.id}/glue_job/create_prior_parquet.py"
    python_version  = "3"
  }
}

resource "aws_glue_job" "job2" {
  name         = "create_4_features"
  role_arn     = aws_iam_role.glue_job_role.arn
  glue_version = "3.0"

  command {
    script_location = "s3://${aws_s3_bucket.source_code.id}/glue_job/create_4_features(parquet).py"
    python_version  = "3"
  }
}


resource "aws_glue_job" "job3" {
  name         = "create_results"
  role_arn     = aws_iam_role.glue_job_role.arn
  glue_version = "3.0"

  command {
    script_location = "s3://${aws_s3_bucket.source_code.id}/glue_job/create_results(csv).py"
    python_version  = "3"
  }
}