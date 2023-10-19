module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  //for_each = var.instances
  name = "catalogue-dev"
    ami = local.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${local.sg_id}"]
  subnet_id              =  local.private_subnet_ids[0]
    instance_tags = merge({
        "Name" = "catalogue-dev"
    },{
        "environment" = "Dev"
        "terraform" = "true"
    })
    
}
