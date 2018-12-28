resource "aws_launch_template" "ecs_instance_template" {
    name                                    = "${var.project_name}-${var.environment}-launch-template"
    image_id                                = "${var.ecs_optimized_ami}"
    instance_type                           = "${var.instance_size}"
    key_name                                = "${var.key_name}"
    instance_initiated_shutdown_behavior    = "terminate"
    disable_api_termination                 = true
    ebs_optimized                           = true
    vpc_security_group_ids                  = ["${var.instance_security_groups}"]
    user_data                               = "${base64encode("${data.template_file.user_data.rendered}")}"

    block_device_mappings {
        device_name                         = "/dev/xvda"
        ebs {
            volume_size                     = 50
            delete_on_termination           = true
            volume_type                     = "gp2"
        }
    }

    block_device_mappings {
        device_name                         = "/dev/xvdcz"
        ebs {
            volume_size                     = 200
            delete_on_termination           = true
            volume_type                     = "gp2"
        }
    }

    iam_instance_profile {
        name                                = "${aws_iam_instance_profile.ecs_instance_profile.name}"
    }

    monitoring {
        enabled                             = false
    }

    tag_specifications {
        resource_type                       = "instance"
        tags {
            Name                            = "${var.project_name}-${var.environment}-instance"
            Cluster                         = "${var.project_name}-${var.environment}-cluster"
            Environment                     = "${var.environment}"
            Project                         = "${var.project_name}"
            Terraform                       = "True"
        }
    }
    tag_specifications {
        resource_type                       = "volume"
        tags {
            Name                            = "${var.project_name}-${var.environment}-volume"
            Environment                     = "${var.environment}"
            Project                         = "${var.project_name}"
            Terraform                       = "True"
        }
    }
}

data "template_file" "user_data" {
    template                                = "${file("${path.module}/userdata/ecs_instance.tpl")}"

    vars {
        cluster_name                        = "${var.project_name}-${var.environment}-cluster"
        efs_tmp_mount_point                 = "/mnt/efs_tmp"
        efs_tmp_dns_name                    = "${aws_efs_file_system.ecs_efs_tmp.dns_name}"
    }
}
