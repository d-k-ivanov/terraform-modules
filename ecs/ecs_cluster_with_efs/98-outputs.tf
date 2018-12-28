output "ecs_instance_role_arn" {
    value = "${aws_iam_role.ecs_instance_role.arn}"
}

output "ecs_task_role_arn" {
    value = "${aws_iam_role.ecs_default_task.arn}"
}

output "ecs_cluster_arn" {
    value = "${aws_ecs_cluster.ecs_cluster.arn}"
}

output "ecs_load_balancer_arn" {
    value = "${aws_lb.ecs_alb.arn}"
}

# output "ecs_alb_listener_443_arn" {
#     value = "${aws_lb_listener.ecs_alb_listener_443.arn}"
# }

# output "ecs_discovery_private_namespace_id" {
#     value = "${aws_service_discovery_private_dns_namespace.ecs_discovery_private_namespace.id}"
# }
