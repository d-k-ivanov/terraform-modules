esource "aws_s3_bucket" "remote_tf_state_bucket" {
    bucket          = "${var.bucket_name}"
    acl             = "private"
    region          = "${var.region}"
    versioning {
        enabled     = true
    }
    tags {
        Terraform = "True"
        Contact = "${var.contact}"
    }
}
