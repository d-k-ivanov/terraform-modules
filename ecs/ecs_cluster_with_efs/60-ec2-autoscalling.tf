# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html
resource "aws_autoscaling_group" "ecs_asg" {
    name                    = "${var.project_name}-${var.environment}-asg"
    min_size                = "${var.capacity_min}"
    max_size                = "${var.capacity_max}"
    desired_capacity        = "${var.capacity_desired}"
    force_delete            = true
    vpc_zone_identifier     = ["${var.private_subnets}"]

    launch_template         = {
        id                  = "${aws_launch_template.ecs_instance_template.id}"
        version             = "$$Latest"
    }

    tag {
        key                 = "Name"
        value               = "${var.project_name}-${var.environment}-ecs-cluster-asg"
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

    depends_on = ["aws_efs_file_system.ecs_efs_tmp"]
}
