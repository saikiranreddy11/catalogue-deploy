locals {
    private_cidr_block = split(",",data.aws_ssm_parameter.private_subnets.value)
   
    ami_id = data.aws_ami.devops_ami.id
}

output "version"{
value = var.package_version
}