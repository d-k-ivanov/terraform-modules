resource "aws_iam_user" "cloudwatch_read_user" {
    name                            = "${var.project_name}-${var.environment}-perf-test"
}

resource "aws_iam_access_key" "cloudwatch_read_user_key" {
    user                            = "${aws_iam_user.cloudwatch_read_user.name}"
    pgp_key                         = "${var.pgp_key}"
}

resource "aws_iam_user_login_profile" "cloudwatch_read_user_profile" {
    user                            = "${aws_iam_user.cloudwatch_read_user.name}"
    pgp_key                         = "${var.pgp_key}"
    password_reset_required         = false
    password_length                 = 20

}

resource "aws_iam_user_policy" "cloudwatch_read_user_policy" {
    name                            = "${var.project_name}-${var.environment}-perf-test-policy"
    user                            = "${aws_iam_user.cloudwatch_read_user.name}"
    policy                          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:DescribeMetricFilters"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams",
                "logs:FilterLogEvents",
                "logs:GetLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:/${var.project_name}-${var.environment}-*"
            ]
        }
    ]
}
EOF
}

output "cloudwatch_read_username" {
    value                           = "${aws_iam_user.cloudwatch_read_user.name}"
}

output "cloudwatch_read_access_key" {
    value                           = "${aws_iam_access_key.cloudwatch_read_user_key.id}"
}

output "cloudwatch_read_access_secret" {
    value                           = "${aws_iam_access_key.cloudwatch_read_user_key.encrypted_secret}"
}

output "cloudwatch_read_password" {
    value                           = "${aws_iam_user_login_profile.cloudwatch_read_user_profile.encrypted_password}"
}
