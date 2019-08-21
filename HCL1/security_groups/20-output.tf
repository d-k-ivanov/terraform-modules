output "ecs_instance_sg" {
    value = "${aws_security_group.ecs_instance_sg.id}"
}

output "bastion_public_sg" {
    value = "${aws_security_group.bastion_public_sg.id}"
}

output "alb_public_sg" {
    value = "${aws_security_group.alb_public_sg.id}"
}
