resource "aws_launch_template" "instance_template" {
    count                                   = "${var.is_mq_needed}"
    name                                    = "${var.project_name}-${var.environment}-mq-launch-template"
    image_id                                = "ami-b5ed9ccd"
    instance_type                           = "${var.mq_instance_size}"
    key_name                                = "${var.key_name}"
    instance_initiated_shutdown_behavior    = "terminate"
    disable_api_termination                 = true
    vpc_security_group_ids                  = ["${var.security_groups}"]
    user_data                               = "${base64encode("${data.template_file.user_data.rendered}")}"

    block_device_mappings {
        device_name                         = "/dev/sda1"
        ebs {
            volume_size                     = 50
            delete_on_termination           = true
            volume_type                     = "gp2"
        }
    }

    iam_instance_profile {
        name                                = "${aws_iam_instance_profile.instance_profile.name}"
    }

    monitoring {
        enabled                             = false
    }

    tag_specifications {
        resource_type                       = "instance"
        tags {
            Name                            = "${var.project_name}-${var.environment}-mq-instance"
            Cluster                         = "${var.project_name}-${var.environment}-mq-cluster"
            Environment                     = "${var.environment}"
            Project                         = "${var.project_name}"
            Terraform                       = "True"
        }
    }
    tag_specifications {
        resource_type                       = "volume"
        tags {
            Name                            = "${var.project_name}-${var.environment}-mq-volume"
            Environment                     = "${var.environment}"
            Project                         = "${var.project_name}"
            Terraform                       = "True"
        }
    }
}

data "template_file" "user_data" {
    template                                = "${file("${path.module}/userdata/rabbit_instance.tpl")}"

    vars {
        erlang_cookie                       = "${var.mq_erlang_cookie}"
    }
}
