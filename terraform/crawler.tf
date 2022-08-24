
resource "aws_glue_catalog_database" "imba_small" {
  name = "imba_small"
}

resource "aws_glue_crawler" "example" {
  database_name = aws_glue_catalog_database.imba_small.name
  name          = "imba_small_dataset"
  role          = aws_iam_role.glue_crawler_role.arn

  s3_target {
    path = "s3://imba-aws/data"
  }
}

