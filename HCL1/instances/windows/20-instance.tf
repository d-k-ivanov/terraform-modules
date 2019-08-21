data "template_file" "user_data" {
    template                                = "${file("${path.module}/files/windows_instance.tpl")}"
}

resource "aws_instance" "instance" {
    count                           = "${var.is_instance_needed}"
    ami                             = "ami-08d9defbf2bfd89bd"
    instance_type                   = "m5.xlarge"
    iam_instance_profile            = "${aws_iam_instance_profile.instance_profile.id}"
    key_name                        = "${var.key_name}"
    subnet_id                       = "${var.subnet}"
    vpc_security_group_ids          = ["${var.security_groups}"]
    user_data_base64                = "${base64encode("${data.template_file.user_data.rendered}")}"
    associate_public_ip_address     = true
    tags {
        Name                        = "${var.project_name}-${var.environment}-windows"
        Environment                 = "${var.environment}"
        Project                     = "${var.project_name}"
        Terraform                   = "True"
    }
}
