resource "aws_s3_bucket" "source_code" {
  bucket = var.bucket_name

  tags = {
    Environment = "test"
  }
}

resource "aws_s3_bucket_acl" "source_code" {
  bucket = aws_s3_bucket.source_code.id
  acl    = "private"
}


data "archive_file" "lambda_function" {
  for_each    = fileset("../scripts/lambda", "*.py")
  type        = "zip"
  source_file = "../scripts/lambda/${each.value}"
  output_path = "../scripts/lambda/${each.value}.zip"
}

# resource "aws_s3_object" "object_lambda" {
#   for_each = fileset("../../scripts/lambda", "**")

#   bucket = aws_s3_bucket.source_code.id
#   key    = "lambda/${each.value}"
#   source = "../../scripts/lambda/${each.value}"

#   etag = filemd5("../../scripts/lambda/${each.value}")

# }


resource "aws_s3_object" "object_glue_job" {
  for_each = fileset("../scripts/glue_jobs", "**")

  bucket = aws_s3_bucket.source_code.id
  key    = "glue_job/${each.value}"
  source = "../scripts/glue_jobs/${each.value}"

  etag = filemd5("../scripts/glue_jobs/${each.value}")

}

