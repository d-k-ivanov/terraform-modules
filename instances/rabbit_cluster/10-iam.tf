resource "aws_iam_role" "instance_role" {
    count                           = "${var.is_mq_needed}"
    name                            = "${var.project_name}-${var.environment}-mq-instance-role"
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

resource "aws_iam_role_policy" "instance_policy" {
    count                           = "${var.is_mq_needed}"
    name                            = "${var.project_name}-${var.environment}-mq-instance-policy"
    role                            = "${aws_iam_role.instance_role.id}"
    policy                          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
    count                           = "${var.is_mq_needed}"
    name                            = "${var.project_name}-${var.environment}-mq-instance-profile"
    path                            = "/"
    role                            = "${aws_iam_role.instance_role.name}"
}
