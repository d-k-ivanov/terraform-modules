resource "aws_iam_user" "data_bucket_user" {
    count                           = "${var.is_s3_needed}"
    name                            = "${var.project_name}-${var.environment}-s3-access"
}

resource "aws_iam_access_key" "data_bucket_user_key" {
    count                           = "${var.is_s3_needed}"
    user                            = "${aws_iam_user.data_bucket_user.name}"
    pgp_key                         = "${var.pgp_key}"
}

resource "aws_iam_user_policy" "data_bucket_user_policy" {
    count                           = "${var.is_s3_needed}"
    name                            = "${var.project_name}-${var.environment}-s3-full-access"
    user                            = "${aws_iam_user.data_bucket_user.name}"

    policy                          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:ListKeys",
                "s3:ListAllMyBuckets",
                "kms:GenerateRandom",
                "kms:ListAliases",
                "kms:CreateKey",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "kms:*",
            "Resource": [
                "${var.s3_encryption_key}",
                "arn:aws:kms:us-west-2:*:alias/kms-s3-key-dev"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.project_name}-${var.environment}-data",
                "arn:aws:s3:::${var.project_name}-${var.environment}-data/*"
            ]
        }
    ]
}
EOF
}
