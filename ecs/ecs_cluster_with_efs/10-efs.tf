resource "aws_efs_file_system" "ecs_efs_tmp" {
    creation_token = "${var.project_name}-${var.environment}-efs-tmp"

    tags {
        Name                            = "${var.project_name}-${var.environment}-efs-tmp"
        Cluster                         = "${var.project_name}-${var.environment}-cluster"
        Environment                     = "${var.environment}"
        Project                         = "${var.project_name}"
        Terraform                       = "True"
    }
}

resource "aws_efs_mount_target" "ecs_efs_tmp_alpha_mount" {
    file_system_id                      = "${aws_efs_file_system.ecs_efs_tmp.id}"
    subnet_id                           = "${var.private_subnets[0]}"
    security_groups                     = ["${var.instance_security_groups}"]
}

resource "aws_efs_mount_target" "ecs_efs_tmp_betta_mount" {
    file_system_id                      = "${aws_efs_file_system.ecs_efs_tmp.id}"
    subnet_id                           = "${var.private_subnets[1]}"
    security_groups                     = ["${var.instance_security_groups}"]
}
