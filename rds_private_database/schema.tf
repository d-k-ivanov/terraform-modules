provider "mysql" {
    endpoint                        = "${aws_db_instance.db_instance.endpoint}"
    username                        = "${aws_db_instance.db_instance.username}"
    password                        = "${aws_db_instance.db_instance.password}"
}

resource "mysql_user" "db_user_example" {
    count                           = "${var.is_db_needed}"
    user                            = "example"
    host                            = "%"
    plaintext_password              = "password"
}

resource "mysql_database" "db_example" {
    count                           = "${var.is_db_needed}"
    name                            = "db_example"
    default_character_set           = "utf8"
    default_collation               = "utf8_general_ci"
}

resource "mysql_grant" "db_user_example_grant-db_example" {
    count                           = "${var.is_db_needed}"
    user                            = "${mysql_user.db_user_example.user}"
    host                            = "${mysql_user.db_user_example.host}"
    database                        = "${mysql_database.db_example.name}"
    privileges                      = ["ALL PRIVILEGES"]
}

