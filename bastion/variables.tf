# Global section
variable "region" {
    type = "string"
    description = "AWS region"
}

variable "environment" {
    type = "string"
    description = "Environment name - prod, dev, etc."
}

variable "project_name" {
    type = "string"
    description = "Project name"
}

variable "key_name" {
    type = "string"
    description = "EC2 ssh key name"
}

variable "security_groups" {
    type = "list"
    description = "List of security groups"
}

variable "subnet" {
    type = "string"
    description = "Public subnet"
}
