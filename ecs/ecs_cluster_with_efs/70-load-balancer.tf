resource "aws_lb" "ecs_alb" {
    name                        = "${var.project_name}-${var.environment}-alb"
    internal                    = false
    load_balancer_type          = "application"
    security_groups             = ["${var.alb_security_groups}"]
    subnets                     = ["${var.public_subnets}"]

    tags {
        Name                    = "${var.project_name}-${var.environment}-alb"
        Environment             = "${var.environment}"
        Project                 = "${var.project_name}"
        Terraform               = "True"
    }
}

# resource "aws_lb_target_group" "ecs_alb_tg_443" {
#     name                    = "${var.project_name}-${var.environment}-tg-443"
#     port                    = "443"
#     protocol                = "HTTPS"
#     vpc_id                  = "${var.vpc_id}"

#     tags {
#         Name                = "${var.project_name}-${var.environment}-tg-443"
#         Environment         = "${var.environment}"
#         Project             = "${var.project_name}"
#         Terraform           = "True"
#     }
# }

# resource "aws_lb_listener" "ecs_alb_listener_443" {
#     load_balancer_arn           = "${aws_lb.ecs_alb.arn}"
#     port                        = "443"
#     protocol                    = "HTTPS"
#     ssl_policy                  = "ELBSecurityPolicy-2015-05"
#     certificate_arn             = "${var.ssl_certificate_arn}"

#     default_action {
#         type                    = "fixed-response"
#         fixed_response {
#             content_type        = "text/plain"
#             message_body        = "Page not found"
#             status_code         = "404"
#         }
#     }

#     # default_action {
#     #     type                = "forward"
#     #     target_group_arn    = "${aws_lb_target_group.ecs_alb_tg_443.arn}"
#     # }
# }

# resource "aws_lb_listener" "ecs_alb_listener_80" {
#     load_balancer_arn           = "${aws_lb.ecs_alb.arn}"
#     port                        = "80"
#     protocol                    = "HTTP"

#     default_action {
#         type                    = "redirect"
#         redirect {
#             port                = "443"
#             protocol            = "HTTPS"
#             status_code         = "HTTP_301"
#         }
#     }
# }

# resource "aws_autoscaling_attachment" "ecs_asg_attachment_443" {
#     autoscaling_group_name      = "${aws_autoscaling_group.ecs_asg.id}"
#     alb_target_group_arn        = "${aws_lb_target_group.ecs_alb_tg_443.arn}"
#     port                        = 8080
# }

resource "aws_route53_record" "ecs_alb_domain_record_alias" {
    zone_id                     = "${var.dns_zone_id}"
    name                        = "${var.dns_suffix}"
    type                        = "A"

    alias {
        name                    = "${aws_lb.ecs_alb.dns_name}"
        zone_id                 = "${aws_lb.ecs_alb.zone_id}"
        evaluate_target_health  = true
    }
}

# resource "aws_route53_record" "ecs_alb_domain_record_alias_www" {
#     zone_id                     = "${var.dns_zone_id}"
#     name                        = "www.${var.dns_suffix}"
#     type                        = "A"

#     alias {
#         name                    = "${aws_lb.ecs_alb.dns_name}"
#         zone_id                 = "${aws_lb.ecs_alb.zone_id}"
#         evaluate_target_health  = true
#     }
# }

resource "aws_route53_record" "ecs_alb_domain_record" {
    count                   = "${var.is_wildcard_needed}"
    zone_id                 = "${var.dns_zone_id}"
    name                    = "*.${var.dns_suffix}"
    type                    = "CNAME"
    ttl                     = "300"

    records = [
      "${aws_lb.ecs_alb.dns_name}",
    ]
}
