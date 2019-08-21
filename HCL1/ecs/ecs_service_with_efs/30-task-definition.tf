resource "aws_ecs_task_definition" "ecs_task_definition" {
    family                      = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
    container_definitions       = "${data.template_file.ecs_task_definition_template.rendered}"
    task_role_arn               = "${var.ecs_service_arn}"
    execution_role_arn          = "${var.ecs_service_arn}"
    # requires_compatibilities    = ["EC2"]
    # memory                      = "1024"
    # network_mode                = "awsvpc"
    network_mode                = "bridge"

    volume {
        name                    = "shared-tmp-volume"
        host_path               = "/mnt/efs_tmp"
    }

    placement_constraints {
        type                    = "memberOf"
        expression              = "attribute:ecs.availability-zone in [${var.region}a, ${var.region}b]"
    }
}
