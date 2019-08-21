resource "aws_security_group" "ecs_instance_sg" {
    name                = "${var.project_name}-${var.environment}-ecs-instance-sg"
    description         = "SG for ECS instances in ${var.project_name} ${var.environment}"
    vpc_id              = "${var.vpc_id}"

    tags {
        Name            = "${var.project_name}-${var.environment}-ecs-instance-sg"
        Environment     = "${var.environment}"
        Project         = "${var.project_name}"
        Terraform       = "True"
    }
}

resource "aws_security_group_rule" "ecs_instance_rule_allow_self" {
    type                = "ingress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    self                = true
    security_group_id   = "${aws_security_group.ecs_instance_sg.id}"
}

resource "aws_security_group_rule" "ecs_instance_sg_rule_allow_outbound" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.ecs_instance_sg.id}"
}
