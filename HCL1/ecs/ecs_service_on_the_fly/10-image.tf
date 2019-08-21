
data "template_file" "ecr_policy" {
    template                    = "${file("${path.module}/templates/ecr_policy.tpl.json")}"

    vars {
        project_name            = "${var.project_name}"
        environment             = "${var.environment}"
        ecs_instance_role_arn   = "${var.ecs_instance_role_arn}"
        ecs_task_role_arn       = "${var.ecs_task_role_arn}"
    }
}

resource "aws_ecr_repository" "docker_service_ecr_repo" {
    name                        = "${var.project_name}-${var.environment}-docker-service"
}

resource "aws_ecr_repository_policy" "docker_service_ecr_repo_policy" {
    repository                  = "${aws_ecr_repository.docker_service_ecr_repo.name}"
    policy                      = "${data.template_file.ecr_policy.rendered}"
}

data "external" "check_local_image" {
    program                     = ["python", "${path.module}/bin/check_local_image.py", "-i", "${aws_ecr_repository.docker_service_ecr_repo.repository_url}", "-t", "${var.image_version}"]
}

resource "null_resource" "build_docker_image" {
    depends_on                  = ["aws_ecr_repository.docker_service_ecr_repo"]

    triggers {
        image_exist             = "${data.external.check_local_image.result.id}"
    }

    provisioner "local-exec" {
        command                 = "docker build --rm --tag ${aws_ecr_repository.docker_service_ecr_repo.repository_url}:${var.image_version} ${path.module}/image"
    }
}

data "external" "login_to_ecr" {
    program                     = ["python", "${path.module}/bin/login_to_ecr.py", "-r", "${var.region}", "-a", "${var.aws_access_key}", "-s", "${var.aws_secret_key}"]
}

resource "null_resource" "push_docker_image" {
    depends_on                  = [
        "aws_ecr_repository.docker_service_ecr_repo",
        "null_resource.build_docker_image"
    ]

    triggers {
        image_exist             = "${data.external.check_local_image.result.id}"
    }

    provisioner "local-exec" {
        command                 = "docker push ${aws_ecr_repository.docker_service_ecr_repo.repository_url}:${var.image_version}"
    }
}
