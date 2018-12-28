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
                    "arn:aws:iam::402242608736:role/data-migration-access"
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
                    "arn:aws:iam::402242608736:role/data-migration-access"
                ]
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.project_name}-${var.environment}-data/*"
        }
    ]
}
EOF
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
