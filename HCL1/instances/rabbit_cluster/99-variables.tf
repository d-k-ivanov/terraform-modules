variable "region"                   {}
variable "aws_access_key"           {}
variable "aws_secret_key"           {}
variable "environment"              {}
variable "project_name"             {}

# Instance
variable "mq_instance_size"         {}
variable "mq_number_of_nodes"       {}
variable "key_name"                 {}

# Network
variable "vpc_id"                   {}
variable "subnet_ids"               {
    type = "list"
}

# Security
variable "mq_erlang_cookie"         {}
variable "security_groups"          {
    type = "list"
}

# Enable or disable deploy of services
variable "is_mq_needed"             {}
