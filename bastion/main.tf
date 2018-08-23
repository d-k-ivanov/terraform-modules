provider "aws" {
    region          = "${var.region}"
}

data "aws_ami" "amazonlinux" {
    most_recent                 = true
    owners                      = ["137112412989"]
    name_regex                  = "^amzn-ami-hvm-.*-gp2$"
    filter {
        name                    = "architecture"
        values                  = ["x86_64"]
    }
    filter {
        name                    = "root-device-type"
        values                  = ["ebs"]
    }
    filter {
        name                    = "virtualization-type"
        values                  = ["hvm"]
    }
}

resource "aws_iam_role" "bastion_instance_role" {
  name                          = "${var.project_name}_${var.environment}_bastion_instance_role"
  assume_role_policy            = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name                          = "${var.project_name}_${var.environment}_bastion_instance_profile"
  path                          = "/"
  role                          = "${aws_iam_role.bastion_instance_role.name}"
}

resource "aws_instance" "bastion" {
    ami                         = "${data.aws_ami.amazonlinux.id}"
    instance_type               = "t2.micro"
    iam_instance_profile        = "${aws_iam_instance_profile.bastion_instance_profile.id}"
    key_name                    = "${var.key_name}"
    subnet_id                   = "${var.subnet}"
    vpc_security_group_ids      = ["${var.security_groups}"]
    associate_public_ip_address = true
    tags {
        Name                    = "${var.project_name}-${var.environment}-bastion"
        Environment             = "${var.environment}"
        Project                 = "${var.project_name}"
        Terraform               = "True"
    }
}

