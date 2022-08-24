resource "aws_iam_role" "lambda_role" {
  name = "terraform_aws_lambda_role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  assume_role_policy = <<-EOF
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
EOF
}





resource "aws_iam_role" "glue_job_role" {
  name = "terraform_aws_glue_job_role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  assume_role_policy = <<-EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "glue.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}


resource "aws_iam_role" "glue_crawler_role" {
  name = "terraform_aws_crawler_job_role"
  managed_policy_arns= ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",]
  assume_role_policy = <<-EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "glue.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "policy" {
  name = "crowler_role_to_s3"
  path = "/"

  policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Resource = [
          "arn:aws:s3:::imba-aws/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = aws_iam_policy.policy.arn
}