resource "aws_cloudwatch_log_group" "ecs_log_group" {
    name                = "/${var.project_name}-${var.environment}-${var.sub_environment}/${var.service_name}"
    retention_in_days   = 30

    tags {
        Name            = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
        Environment     = "${var.environment}"
        Project         = "${var.project_name}"
        Terraform       = "True"
    }
}
