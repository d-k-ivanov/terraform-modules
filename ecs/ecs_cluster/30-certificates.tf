resource "aws_acm_certificate" "ecs_cluster" {
    domain_name                 = "*.${var.environment}.${var.dns_suffix}"
    subject_alternative_names   = [
        "${var.environment}.${var.dns_suffix}",
    ]
    validation_method = "DNS"

    tags {
        Name                    = "${var.project_name}-${var.environment}-certificate"
        Cluster                 = "${var.project_name}-${var.environment}-cluster"
        Environment             = "${var.environment}"
        Project                 = "${var.project_name}"
        Terraform               = "True"
        }
}

resource "aws_route53_record" "ecs_cluster_certificate_verification" {
    count   = "2"
    name    = "${lookup(aws_acm_certificate.ecs_cluster.domain_validation_options[count.index], "resource_record_name")}"
    type    = "${lookup(aws_acm_certificate.ecs_cluster.domain_validation_options[count.index], "resource_record_type")}"
    zone_id = "${var.dns_zone_id}"
    records = ["${lookup(aws_acm_certificate.ecs_cluster.domain_validation_options[count.index], "resource_record_value")}"]
    ttl     = 300
}

resource "aws_acm_certificate_validation" "ecs_cluster_certificate_validation" {
    certificate_arn             = "${aws_acm_certificate.ecs_cluster.arn}"
    validation_record_fqdns     = [
        "${aws_route53_record.ecs_cluster_certificate_verification.*.fqdn}",
    ]
}
