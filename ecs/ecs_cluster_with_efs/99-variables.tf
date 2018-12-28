# Global section
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

variable "dns_zone_id" {
    type        = "string"
    description = "Hosted Zone ID"
}

variable "dns_suffix" {
    type        = "string"
    description = "DNS suffix"
}

variable "ssl_certificate_arn" {
    type        = "string"
    description = "ARN of SSL certificate"
}

# EC2 section
variable "ecs_optimized_ami" {
    type        = "string"
    description = "ECS optimized AMI ID"
}

variable "instance_size" {
    type        = "string"
    description = "EC2 instance size"
}

variable "key_name" {
    type        = "string"
    description = "EC2 ssh key name"
}

variable "instance_security_groups" {
    type        = "list"
    description = "List of instance security groups"
}

variable "alb_security_groups" {
    type        = "list"
    description = "List of alb security groups"
}

# ASG section
variable "capacity_max" {
    type        = "string"
    default     = "1"
    description = "ASG max number of instances"
}

variable "capacity_min" {
    type        = "string"
    default     = "1"
    description = "ASG min number of instances"
}

variable "capacity_desired" {
    type        = "string"
    default     = "1"
    description = "ASG desired number of instances"
}

# Networks
variable "vpc_id" {
    type        = "string"
    description = "VPC ID"
}

variable "private_subnets" {
    type        = "list"
    description = "List of private VPC subnets"
}

variable "public_subnets" {
    type        = "list"
    description = "List of public VPC subnets"
}

# Enable or disable deploy of services
variable "is_wildcard_needed"         {}
