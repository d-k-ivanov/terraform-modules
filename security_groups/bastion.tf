resource "aws_security_group" "bastion_public_sg" {
    name                = "${var.project_name}-${var.environment}-bastion-public-sg"
    description         = "SG for ECS instances in ${var.project_name} ${var.environment}"
    vpc_id              = "${var.vpc_id}"

    tags {
        Name            = "${var.project_name}-${var.environment}-bastion-public-sg"
        Environment     = "${var.environment}"
        Project         = "${var.project_name}"
        Terraform       = "True"
    }
}

resource "aws_security_group_rule" "bastion_public_rule_allow_SSH" {
    type                = "ingress"
    from_port           = 22
    to_port             = 22
    protocol            = "TCP"
    # TODO: strict cidr list (ormco and hcl only). !DO NOT USE FOR PRODUCTION!
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.bastion_public_sg.id}"
}
