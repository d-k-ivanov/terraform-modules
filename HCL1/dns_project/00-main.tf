provider "aws" {
    region              = "${var.region}"
    access_key          = "${var.aws_access_key}"
    secret_key          = "${var.aws_secret_key}"
}

resource "aws_route53_zone" "project_dns_zone" {
    name                = "${var.project_name}.${var.parent_dns_suffix}"

    tags {
        Name            = "${var.project_name}-dns-zone"
        Project         = "${var.project_name}"
        Terraform       = "True"
    }
}

resource "aws_route53_record" "project_dns_zone_ns" {
    zone_id             = "${var.parent_dns_zone_id}"
    name                = "${var.project_name}.${var.parent_dns_suffix}"
    type                = "NS"
    ttl                 = "300"

    records             = [
        "${aws_route53_zone.project_dns_zone.name_servers.0}",
        "${aws_route53_zone.project_dns_zone.name_servers.1}",
        "${aws_route53_zone.project_dns_zone.name_servers.2}",
        "${aws_route53_zone.project_dns_zone.name_servers.3}",
    ]
}
