resource "aws_ses_domain_identity" "ses_domain" {
  domain            = "${var.dns_zone_name}"
}

resource "aws_route53_record" "ses_domain_verification_record" {
  zone_id           = "${var.dns_zone_id}"
  name              = "_amazonses.${var.dns_zone_name}"
  type              = "TXT"
  ttl               = "600"
  records           = ["${aws_ses_domain_identity.ses_domain.verification_token}"]
}

resource "aws_ses_domain_identity_verification" "ses_domain_verification" {
  domain            = "${aws_ses_domain_identity.ses_domain.id}"
  depends_on        = ["aws_route53_record.ses_domain_verification_record"]
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain            = "${aws_ses_domain_identity.ses_domain.domain}"
}

resource "aws_route53_record" "ses_domain_dkim_verification_record" {
  count             = 3
  zone_id           = "${var.dns_zone_id}"
  name              = "${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}._domainkey"
  type              = "CNAME"
  ttl               = "600"
  records           = ["${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_domain_spf_record_txt" {
  zone_id           = "${var.dns_zone_id}"
  name              = "${var.dns_zone_name}"
  type              = "TXT"
  ttl               = "600"
  records           = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_route53_record" "ses_domain_mx" {
  zone_id           = "${var.dns_zone_id}"
#   name              = "${aws_ses_domain_mail_from.ses_from_domain.mail_from_domain}"
  name              = "${var.dns_zone_name}"
  type              = "MX"
  ttl               = "600"
  records           = ["10 feedback-smtp.us-west-2.amazonses.com"]
}

resource "aws_route53_record" "ses_domain_dmarc" {
  zone_id           = "${var.dns_zone_id}"
  name              = "_dmarc.${var.dns_zone_name}"
  type              = "TXT"
  ttl               = "600"
  records           = ["v=DMARC1; p=none; rua=mailto:${var.dmarc_email}; ruf=mailto:${var.dmarc_email}; fo=1"]
}

# !!! Those settings need to create username with "Generate"-bases SMTP acces
# !!! To obtain common SMTP user and password use AWS SES Console
resource "aws_iam_user" "ses_username" {
  name              = "ses-${replace(var.dns_zone_name, ".", "-")}"
}

resource "aws_iam_user_policy" "ses_policy" {
  name              = "ses_policy_allow"
  user              = "${aws_iam_user.ses_username.name}"

  policy            = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ses:SendRawEmail",
            "Resource": "*"
        }
    ]
}
EOF
}
