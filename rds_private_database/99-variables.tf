variable "region"                   {}
variable "aws_access_key"           {}
variable "aws_secret_key"           {}
variable "environment"              {}
variable "project_name"             {}

# Instance
variable "db_instance_size"         {}

# Network
variable subnet_ids                 {
    type = "list"
}

# Security
variable "root_password"            {}
variable "security_groups"          {
    type = "list"
}

# Enable or disable deploy of services
variable "is_db_needed"             {}
