provider "aws" {
    region                          = "${var.region}"
    access_key                      = "${var.aws_access_key}"
    secret_key                      = "${var.aws_secret_key}"
}

data "aws_caller_identity" "current" {}

data "template_file" "cloudtrail_logs_policy" {
    template                        = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.project_name}-${var.environment}-cloudtrail-logs"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.project_name}-${var.environment}-cloudtrail-logs/AWSLogs/$${account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF

    vars {
      account_id = "${data.aws_caller_identity.current.account_id}"
    }
}

resource "aws_s3_bucket" "log_bucket" {
    count                           = "${var.is_s3_needed}"
    bucket                          = "${var.project_name}-${var.environment}-cloudtrail-logs"
    acl                             = "log-delivery-write"
    policy                          = "${data.template_file.cloudtrail_logs_policy.rendered}"

    tags {
        Name                        = "${var.project_name}-${var.environment}-log-bucket"
        Environment                 = "${var.environment}"
        Project                     = "${var.project_name}"
        Terraform                   = "True"
    }
}

data "template_file" "data_bucket_policy" {
    template                        = <<EOF
{
    "Version": "2008-10-17",
    "Id": "Policy1357935677554",
    "Statement": [
        {
            "Sid": "Stmt1357935647218",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::$${account_id}:role/s3-migration-role"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.project_name}-${var.environment}-data"
        },
        {
            "Sid": "Stmt1357935676138",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::$${account_id}:role/s3-migration-role"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.project_name}-${var.environment}-data/*"
        }
    ]
}
EOF

    vars {
      account_id = "${data.aws_caller_identity.current.account_id}"
    }
}

resource "aws_s3_bucket" "data_bucket" {
    count                           = "${var.is_s3_needed}"
    bucket                          = "${var.project_name}-${var.environment}-data"
    acl                             = "public-read"
    policy                          = "${data.template_file.data_bucket_policy.rendered}"

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = "${var.s3_encryption_key}"
                sse_algorithm     = "aws:kms"
            }
        }
    }

    logging {
        target_bucket = "${aws_s3_bucket.log_bucket.id}"
    }

    tags {
        Name                        = "${var.project_name}-${var.environment}-data-bucket"
        Environment                 = "${var.environment}"
        Project                     = "${var.project_name}"
        Terraform                   = "True"
    }

}

resource "aws_cloudtrail" "cloudtrail" {
    count                           = "${var.is_s3_needed}"
    name                            = "${var.project_name}-${var.environment}-cloudtrail"
    s3_bucket_name                  = "${aws_s3_bucket.log_bucket.id}"
    include_global_service_events   = false

    event_selector {
        read_write_type = "All"
        include_management_events = true

        data_resource {
            type   = "AWS::S3::Object"
            # Make sure to append a trailing '/' to your ARN if you want
            # to monitor all objects in a bucket.
            values = ["${aws_s3_bucket.data_bucket.arn}/"]
        }
    }

    tags {
        Name                        = "${var.project_name}-${var.environment}-cloudtrail"
        Environment                 = "${var.environment}"
        Project                     = "${var.project_name}"
        Terraform                   = "True"
    }
}
