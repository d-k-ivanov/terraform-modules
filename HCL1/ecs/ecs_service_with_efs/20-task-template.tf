
data "template_file" "ecs_task_definition_template" {
    template                    = "${file("${path.module}/task_definitions/task-template.json")}"
    vars {
        project_name            = "${var.project_name}"
        environment             = "${var.environment}"
        # task_name               = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
        task_name               = "${var.service_name}"
        # hostname                = "${var.service_name}.${var.environment}.${var.dns_suffix}"
        task_image              = "303655048530.dkr.ecr.${var.region}.amazonaws.com/${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}:${var.service_version}"
        task_port               = "${var.service_port}"
        task_cpu                = "${var.service_cpu}"
        task_mem                = "${var.service_mem}"
        java_opts               = "${var.java_opts}"
        log_group_name          = "/${var.project_name}-${var.environment}-${var.sub_environment}/${var.service_name}"
        log_group_region        = "${var.region}"
        log_group_prefix        = "${var.project_name}-${var.environment}-${var.sub_environment}"
    }
}
