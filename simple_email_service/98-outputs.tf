output "access_key" {
    value                           = "${aws_iam_access_key.ses_user_key.*.id}"
}

output "smtp_password" {
    value                           = "${aws_iam_access_key.ses_user_key.*.ses_smtp_password}"
}
