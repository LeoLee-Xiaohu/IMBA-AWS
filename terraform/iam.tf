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


# resource "aws_iam_role_policy_attachment" "policy_cloudwatch_access" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
# }

# resource "aws_iam_role_policy_attachment" "policy_glue_access" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
# }

# resource "aws_iam_role_policy_attachment" "policy_s3_access" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }



resource "aws_iam_role" "glue_job_role" {
  name = "terraform_aws_glue_job_role"

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

resource "aws_iam_role_policy_attachment" "policy_cloudwatch_access_glue" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "policy_glue_access_glue" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_role_policy_attachment" "policy_s3_access_glue" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}