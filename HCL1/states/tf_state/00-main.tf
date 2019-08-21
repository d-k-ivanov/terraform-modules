provider "aws" {
    region                          = "${var.region}"
    access_key                      = "${var.aws_access_key}"
    secret_key                      = "${var.aws_secret_key}"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "data_bucket_user" {
    count                           = "${var.is_s3_tf_state_needed}"
    name                            = "${var.project_name}-terrafrom-state-user"
}

resource "aws_iam_access_key" "data_bucket_user_key" {
    count                           = "${var.is_s3_tf_state_needed}"
    user                            = "${aws_iam_user.data_bucket_user.name}"
    pgp_key                         = "${var.pgp_key}"
}

resource "aws_iam_user_policy" "data_bucket_user_policy" {
    count                           = "${var.is_s3_tf_state_needed}"
    name                            = "${var.project_name}-terrafrom-state-access"
    user                            = "${aws_iam_user.data_bucket_user.name}"

    policy                          = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.project_name}-tf-states"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::o${var.project_name}-tf-states/*"
    }
  ]
}
EOF
}
