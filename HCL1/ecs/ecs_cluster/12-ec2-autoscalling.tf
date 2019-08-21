# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html
resource "aws_autoscaling_group" "ecs_asg" {
    name                    = "${var.project_name}-${var.environment}-asg"
    max_size                = "${var.max_size}"
    min_size                = "${var.min_size}"
    desired_capacity        = "${var.desired_capacity}"
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
}
