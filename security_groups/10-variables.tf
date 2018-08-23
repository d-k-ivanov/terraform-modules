variable "region" {
    type        = "string"
    description = "AWS region"
}

variable "environment" {
    type        = "string"
    description = "Environment name - prod, dev, etc."
}

variable "project_name" {
    type        = "string"
    description = "Project name"
}

variable "vpc_id" {
    type        = "string"
    description = "VPC ID"
}
