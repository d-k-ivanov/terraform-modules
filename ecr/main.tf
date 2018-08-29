provider "aws" {
    region                      = "${var.region}"
}

data "template_file" "ecr_policy" {
    template                    = "${file("${path.module}/ecr_policy.tpl")}"

    vars {
        project                 = "${var.project_name}"
        environment             = "${var.environment}"
        ecs_instance_role_arn   = "${var.ecs_instance_role_arn}"
    }
}
