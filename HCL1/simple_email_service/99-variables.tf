variable "region"               {}
variable "aws_access_key"       {}
variable "aws_secret_key"       {}
variable "environment"          {}
variable "project_name"         {}
variable "dns_zone_id"          {}
variable "dns_zone_name"        {}

# Security
variable "pgp_key"              {}

# Enable or disable deploy of services
variable "is_ses_user_needed"   {}
