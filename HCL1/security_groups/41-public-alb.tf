resource "aws_security_group" "alb_public_sg" {
    name                = "${var.project_name}-${var.environment}-alb-public-sg"
    description         = "SG for ECS instances in ${var.project_name} ${var.environment}"
    vpc_id              = "${var.vpc_id}"

    tags {
        Name            = "${var.project_name}-${var.environment}-bastion-public-sg"
        Environment     = "${var.environment}"
        Project         = "${var.project_name}"
        Terraform       = "True"
    }
}

resource "aws_security_group_rule" "alb_public_sg_rule_allow_outbound" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.alb_public_sg.id}"
}


resource "aws_security_group_rule" "alb_public_sg_rule_allow_HTTP" {
    type                = "ingress"
    from_port           = 80
    to_port             = 80
    protocol            = "TCP"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.alb_public_sg.id}"
}

resource "aws_security_group_rule" "alb_public_sg_rule_allow_HTTPS" {
    type                = "ingress"
    from_port           = 443
    to_port             = 443
    protocol            = "TCP"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.alb_public_sg.id}"
}

