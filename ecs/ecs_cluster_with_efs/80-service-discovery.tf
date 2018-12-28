# resource "aws_service_discovery_private_dns_namespace" "ecs_discovery_private_namespace" {
#     # name              = "${var.environment}.${var.dns_suffix}"
#     name              = "${var.dns_suffix}"
#     description       = "${upper(var.project_name)} ${upper(var.environment)} service discovery"
#     vpc               = "${var.vpc_id}"
# }
