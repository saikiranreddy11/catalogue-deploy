module "catalogue_dev" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  name = "catalogue-dev"
    ami = "${local.ami_id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
   subnet_id              = local.private_cidr_block[0]
   //user_data = file("./user.sh")
    instance_tags = merge({
        "Name" = "catalogue-dev"
    },{
        "environment" = "Dev"
        "terraform" = "true"
    })
    
}

resource "null_resource" "execute_script" {

    triggers ={
        intance_id = module.catalogue_dev.id
        version = var.package_version
    }
  connection {
    type     = "ssh"
    user     = "centos"  # Replace with the appropriate SSH username for your instance
    password = "DevOps321"
    host = module.catalogue_dev.private_ip  # Replace with the IP address or DNS of your instance
  }

    provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }


  provisioner "remote-exec" {
    inline = [
        # "export version=${var.package_version}", # to avaoid the ambiguity , variable name is changed to version
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh ${var.package_version}"
    ]
  }
}
