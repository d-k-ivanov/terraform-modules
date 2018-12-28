provider "aws" {
    region                      = "${var.region}"
    access_key                  = "${var.aws_access_key}"
    secret_key                  = "${var.aws_secret_key}"
}

data "template_file" "ecr_policy" {
    template                    = "${file("${path.module}/ecr_policy.tpl")}"

    vars {
        project                 = "${var.project_name}"
        environment             = "${var.environment}"
        ecs_instance_role_arn   = "${var.ecs_instance_role_arn}"
    }
}
