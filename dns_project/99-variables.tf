# Global section
variable "region"                   {}
variable "aws_access_key"           {}
variable "aws_secret_key"           {}

variable "project_name" {
    type = "string"
    description = "Project name"
}

variable "parent_dns_zone_id" {
    type = "string"
    description = "Parent Hosted Zone ID to create project dns zone"
}

variable "parent_dns_suffix" {
    type = "string"
    description = "Parent DNS suffix to create project dns zone"
}

