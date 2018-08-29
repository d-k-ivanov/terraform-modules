variable "region" {
    type        = "string"
    description = "AWS region"
}

variable "project_name" {
    type        = "string"
    description = "Project name"
}

variable "environment" {
    type        = "string"
    description = "Environment name - prod, dev, etc."
}

variable "ecs_instance_role_arn" {
    type        = "string"
    description = "ARN of ECS instance"
}
