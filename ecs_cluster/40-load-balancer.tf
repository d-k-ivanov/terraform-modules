resource "aws_lb" "ecs_alb" {
    name                    = "${var.project_name}-${var.environment}-alb"
    internal                = false
    load_balancer_type      = "application"
    security_groups         = ["${var.alb_security_groups}"]
    subnets                 = ["${var.public_subnets}"]

    tags {
        Name                = "${var.project_name}-${var.environment}-alb"
        Environment         = "${var.environment}"
        Project             = "${var.project_name}"
        Terraform           = "True"
    }
}

resource "aws_lb_target_group" "ecs_alb_tg_443" {
    name                    = "${var.project_name}-${var.environment}-tg-443"
    port                    = "443"
    protocol                = "HTTPS"
    vpc_id                  = "${var.vpc_id}"

    tags {
        Name                = "${var.project_name}-${var.environment}-tg-443"
        Environment         = "${var.environment}"
        Project             = "${var.project_name}"
        Terraform           = "True"
    }
}

resource "aws_lb_listener" "ecs_alb_listener_443" {
    load_balancer_arn       = "${aws_lb.ecs_alb.arn}"
    port                    = "443"
    protocol                = "HTTPS"
    ssl_policy              = "ELBSecurityPolicy-2015-05"
    certificate_arn         = "${aws_acm_certificate.ecs_cluster.arn}"

    default_action {
        type                = "forward"
        target_group_arn    = "${aws_lb_target_group.ecs_alb_tg_443.arn}"
    }
}

# resource "aws_lb_listener" "ecs_alb_listener_80" {
#     load_balancer_arn       = "${aws_lb.ecs_alb.arn}"
#     port                    = "80"
#     protocol                = "HTTP"

#     default_action {
#         type                = "redirect"
#         redirect {
#             port            = "443"
#             protocol        = "HTTPS"
#             status_code     = "HTTP_301"
#         }
#     }
# }

resource "aws_autoscaling_attachment" "ecs_asg_attachment_443" {
    autoscaling_group_name      = "${aws_autoscaling_group.ecs_asg.id}"
    alb_target_group_arn        = "${aws_lb_target_group.ecs_alb_tg_443.arn}"
}
