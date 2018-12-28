variable "region"                   {}
variable "aws_access_key"           {}
variable "aws_secret_key"           {}

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
