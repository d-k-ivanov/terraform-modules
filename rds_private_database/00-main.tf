provider "aws" {
    region                          = "${var.region}"
    access_key                      = "${var.aws_access_key}"
    secret_key                      = "${var.aws_secret_key}"
}

resource "aws_db_subnet_group" "db_subnets" {
    count                           = "${var.is_db_needed}"
    name                            = "${var.project_name}-${var.environment}"
    subnet_ids                      = ["${var.subnet_ids}"]

    tags {
        Name                        = "${var.project_name}-${var.environment}-db-subnets"
        Environment                 = "${var.environment}"
        Project                     = "${var.project_name}"
        Terraform                   = "True"
    }
}

resource "aws_db_parameter_group" "db_parameters" {
    count                           = "${var.is_db_needed}"
    name                            = "${var.project_name}-${var.environment}"
    family                          = "mysql5.7"

    parameter {
      name                          = "character_set_server"
      value                         = "utf8"
    }

    parameter {
      name                          = "character_set_client"
      value                         = "utf8"
    }

    parameter {
      name                          = "log_bin_trust_function_creators"
      value                         = "1"
      apply_method                  = "pending-reboot"
    }

    parameter {
      name                          = "lower_case_table_names"
      value                         = "1"
      apply_method                  = "pending-reboot"
    }

    # Timeouts
    # parameter {
    #   name                          = "connect_timeout"
    #   value                         = "31536000"
    # }

    # parameter {
    #   name                          = "delayed_insert_timeout"
    #   value                         = "31536000"
    # }

    # parameter {
    #   name                          = "long_query_time"
    #   value                         = "31536000"
    # }

    # parameter {
    #   name                          = "max_execution_time"
    #   value                         = "18446744073709551615"
    # }

    # parameter {
    #   name                          = "net_read_timeout"
    #   value                         = "31536000"
    # }

    # parameter {
    #   name                          = "net_write_timeout"
    #   value                         = "31536000"
    # }

    # parameter {
    #   name                          = "wait_timeout"
    #   value                         = "31536000"
    # }

    tags {
        Name                        = "${var.project_name}-${var.environment}-db-parameters"
        Environment                 = "${var.environment}"
        Project                     = "${var.project_name}"
        Terraform                   = "True"
    }
}

resource "aws_db_instance" "db_instance" {
    count                           = "${var.is_db_needed}"
    allocated_storage               = 200
    backup_retention_period         = 7
    backup_window                   = "03:00-04:00"
    db_subnet_group_name            = "${aws_db_subnet_group.db_subnets.name}"
    engine                          = "mysql"
    engine_version                  = "5.7.17"
    identifier                      = "${var.project_name}-${var.environment}"
    instance_class                  = "${var.db_instance_size}"
    parameter_group_name            = "${aws_db_parameter_group.db_parameters.name}"
    password                        = "${var.root_password}"
    publicly_accessible             = false
    storage_type                    = "gp2"
    username                        = "root"
    vpc_security_group_ids          = ["${var.security_groups}"]

    lifecycle {
        ignore_changes = [
            "snapshot_identifier",
        ]
    }

    tags {
        Name                        = "${var.project_name}-${var.environment}-database"
        Environment                 = "${var.environment}"
        Project                     = "${var.project_name}"
        Terraform                   = "True"
    }
}
