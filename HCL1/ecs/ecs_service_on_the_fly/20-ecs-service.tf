resource "aws_cloudwatch_log_group" "ecs_log_group" {
    name                                = "/${var.project_name}-${var.environment}/docker-service"
    retention_in_days                   = 30

    tags {
        Name                            = "${var.project_name}-${var.environment}-docker-service"
        Environment                     = "${var.environment}"
        Project                         = "${var.project_name}"
        Terraform                       = "True"
    }
}

data "template_file" "ecs_task_definition_template" {
    template                            = "${file("${path.module}/templates/task.tpl.json")}"
    vars {
        project_name                    = "${var.project_name}"
        environment                     = "${var.environment}"
        task_name                       = "docker-service"
        task_image                      = "${aws_ecr_repository.docker_service_ecr_repo.repository_url}:${var.image_version}"
        log_group_name                  = "/${var.project_name}-${var.environment}/docker-service"
        log_group_region                = "${var.region}"
        log_group_prefix                = "${var.project_name}-${var.environment}"
    }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
    family                              = "${var.project_name}-${var.environment}-docker-service"
    container_definitions               = "${data.template_file.ecs_task_definition_template.rendered}"
    task_role_arn                       = "${var.ecs_service_arn}"
    execution_role_arn                  = "${var.ecs_service_arn}"
    network_mode                        = "bridge"
    placement_constraints {
        type                            = "memberOf"
        expression                      = "attribute:ecs.availability-zone in [${var.region}a, ${var.region}b]"
    }
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_service" "ecs_service" {
    name                                = "${var.project_name}-${var.environment}-docker-service"
    cluster                             = "${var.ecs_cluster_arn}"
    task_definition                     = "${aws_ecs_task_definition.ecs_task_definition.arn}"
    desired_count                       = 1
    deployment_minimum_healthy_percent  = 50
    deployment_maximum_percent          = 200
    launch_type                         = "EC2"
    scheduling_strategy                 = "REPLICA"

    ordered_placement_strategy          = [
        {
            type                        = "binpack"
            field                       = "memory"
        },
        {
            type                        = "binpack"
            field                       = "cpu"
        },
        {
            type                        = "spread"
            field                       = "attribute:ecs.availability-zone"
        },
        {
            type                        = "spread"
            field                       = "attribute:instanceId"
        },
    ]

    placement_constraints {
        type                            = "memberOf"
        expression                      = "attribute:ecs.availability-zone in [${var.region}a, ${var.region}b]"
    }
}
