data "aws_ssm_parameter" "private_subnets" {
  name = "/roboshop/dev/private_subnet_cidr" 
}

data "aws_ami" "devops_ami" {
 
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_route53_zone" "domain_name" {
  name         = "saikiransudhireddy.com"
  private_zone = false
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/roboshop/dev/catalogue_sg_id" 
}