# data "aws_lb" "ecs_service_lb" {
#   arn  = "${var.ecs_load_balancer_arn}"
# }

resource "aws_lb_listener" "ecs_service_alb_listener" {
    load_balancer_arn           = "${var.ecs_load_balancer_arn}"
    port                        = "${var.service_port}"
    protocol                    = "HTTPS"
    ssl_policy                  = "ELBSecurityPolicy-2015-05"
    certificate_arn             = "${var.ssl_certificate_arn}"

    default_action {
        type                = "forward"
        target_group_arn    = "${aws_lb_target_group.ecs_service_tg.arn}"
    }
}


resource "aws_lb_target_group" "ecs_service_tg" {
    name                    = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
    port                    = "${var.service_port}"
    protocol                = "HTTPS"
    vpc_id                  = "${var.vpc_id}"
    target_type             = "instance"

    health_check {
        path                = "${var.health_check_path}"
        protocol            = "HTTPS"
        interval            = 30
        timeout             = 15
        healthy_threshold   = 2
        unhealthy_threshold = 3
        matcher             = "200,302"
    }

    tags {
        Name                = "${var.project_name}-${var.environment}-${var.sub_environment}-${var.service_name}"
        Environment         = "${var.environment}"
        Project             = "${var.project_name}"
        Terraform           = "True"
    }
}

# redirect_to_dpum
resource "aws_lb_listener_rule" "ecs_service_lb_rule_to_dpum" {
    count                   = "${var.redirect_to_dpum}"
    listener_arn            = "${aws_lb_listener.ecs_service_alb_listener.arn}"
    priority                = 1

    action {
        type                = "redirect"
        redirect {
            host            = "${var.dns_suffix}"
            port            = "8090"
            path            = "/dpum/login.mvc"
            status_code     = "HTTP_302"
        }
    }

    condition {
        field               = "path-pattern"
        values              = ["/"]
    }
}



# resource "aws_lb_listener_rule" "ecs_service_lb_rule" {
#     count                   = "${var.path_pattern_count}"
#     listener_arn            = "${var.ecs_listener_arn}"
#     priority                = "${var.listener_rule_priority + count.index}"

#     action {
#         type                = "forward"
#         target_group_arn    = "${aws_lb_target_group.ecs_service_tg.arn}"
#     }

#     condition {
#         field               = "path-pattern"
#         values              = ["${element(var.path_pattern, count.index)}"]
#     }
# }

# resource "aws_lb_listener_rule" "ecs_service_lb_rule" {
#     listener_arn            = "${var.ecs_listener_arn}"
#     priority                = "${var.listener_rule_priority}"

#     action {
#         type                = "forward"
#         target_group_arn    = "${aws_lb_target_group.ecs_service_tg.arn}"
#     }

#     condition {
#         field               = "host-header"
#         values              = ["${var.service_name}.${var.dns_suffix}"]
#     }
# }
