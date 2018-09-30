provider "aws" {
    region  = "${var.region}"
}

resource "aws_iam_role" "iam_lambda_executor" {
    name = "${var.project_name}-${var.environment}-lambda-executor"

    assume_role_policy = <<EOF
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
