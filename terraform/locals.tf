locals {
    private_cidr_block = split(",",data.aws_ssm_parameter.private_subnets.value)
   
    ami_id = data.aws_ami.devops_ami.id
    current_time = formatdate("YYYY MM DD hh-mm-ss", timestamp())

}

output "version"{
value = var.package_version
}