variable "region"                           {}
variable "aws_access_key"                   {}
variable "aws_secret_key"                   {}
variable "environment"                      {}
variable "project_name"                     {}
variable "key_name"                         {}
variable "subnet"                           {}

variable "security_groups"                  {
    type = "list"
    description = "List of security groups"
}

# Enable or disable deploy of services
variable "is_instance_needed"                 {}
