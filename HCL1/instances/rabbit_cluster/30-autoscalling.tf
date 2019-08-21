resource "aws_lb_target_group" "target_group_5672" {
    count                   = "${var.is_mq_needed}"
    name                    = "${var.project_name}-${var.environment}-mq-5672"
    port                    = 5672
    protocol                = "HTTP"
    vpc_id                  = "${var.vpc_id}"
    target_type             = "instance"

    health_check {
        path                = "/"
        port                = "15672"
        protocol            = "HTTP"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags {
        Name                = "${var.project_name}-${var.environment}-mq"
        Environment         = "${var.environment}"
        Project             = "${var.project_name}"
        Terraform           = "True"
    }
}

resource "aws_autoscaling_group" "asg" {
    count                   = "${var.is_mq_needed}"
    name                    = "${var.project_name}-${var.environment}-mq-asg"
    min_size                = "${var.mq_number_of_nodes}"
    max_size                = "${var.mq_number_of_nodes}"
    desired_capacity        = "${var.mq_number_of_nodes}"
    force_delete            = true
    vpc_zone_identifier     = ["${var.subnet_ids}"]
    target_group_arns       = ["${aws_lb_target_group.target_group_5672.arn}"]

    launch_template         = {
        id                  = "${aws_launch_template.instance_template.id}"
        version             = "$$Latest"
    }

    tag {
        key                 = "Name"
        value               = "${var.project_name}-${var.environment}-mq-cluster-asg"
        propagate_at_launch = "false"
    }

    tag {
        key                 = "Environment"
        value               = "${var.environment}"
        propagate_at_launch = "false"
    }

    tag {
        key                 = "Project"
        value               = "${var.project_name}"
        propagate_at_launch = "false"
    }

    tag {
        key                 = "Terraform"
        value               = "True"
        propagate_at_launch = "false"
    }
}
