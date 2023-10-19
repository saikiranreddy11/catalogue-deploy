module "mongodb" {
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