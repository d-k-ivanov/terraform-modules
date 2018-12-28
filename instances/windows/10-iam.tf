resource "aws_iam_role" "instance_role" {
    count                           = "${var.is_instance_needed}"
    name                            = "${var.project_name}-${var.environment}-windows-instance-role"
    assume_role_policy              = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
    count                           = "${var.is_instance_needed}"
    name                            = "${var.project_name}-${var.environment}-windows-instance-profile"
    path                            = "/"
    role                            = "${aws_iam_role.instance_role.name}"
}
