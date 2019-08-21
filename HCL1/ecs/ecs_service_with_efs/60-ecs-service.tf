data "aws_caller_identity" "current" {}

resource "aws_ecs_service" "ecs_service" {
    name                                = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
    cluster                             = "${var.ecs_cluster_arn}"
    task_definition                     = "${aws_ecs_task_definition.ecs_task_definition.arn}"
    desired_count                       = "${var.service_count}"
    deployment_minimum_healthy_percent  = 50
    deployment_maximum_percent          = 200
    health_check_grace_period_seconds   = 600
    # iam_role                            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
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

    load_balancer {
        target_group_arn                = "${aws_lb_target_group.ecs_service_tg.arn}"
        # container_name                  = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
        container_name                  = "${var.service_name}"
        container_port                  = "${var.service_port}"
        # container_port                  = 80
    }

    placement_constraints {
        type                            = "memberOf"
        expression                      = "attribute:ecs.availability-zone in [${var.region}a, ${var.region}b]"
    }

    # network_configuration {
    #     subnets                         = ["${var.private_subnets}"]
    #     security_groups                 = ["${var.ecs_service_security_groups}"]
    #     assign_public_ip                = false
    # }

    # service_registries {
    #     registry_arn                    = "${aws_service_discovery_service.ecs_service_discovery_service.arn}"
    #     # port                            = "${var.service_port}"
    #     # container_port                  = "${var.service_port}"
    #     # container_name                  = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
    #     container_name                  = "${var.service_name}"
    # }
}
