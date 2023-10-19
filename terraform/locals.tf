locals {
    # vpc_id = module.vpc.vpc.id
    # gw_id = module.vpc.gw.id
    # eip_id = module.vpc.eip.id
    # public_subnet_ids = module.vpc.public_subnet_id[*]
    # private_subnet_ids = module.vpc.private_subnet_id[*]
    # database_subnet_ids = module.vpc.database_subnet_id[*]
    # sg_id = module.sg.sg_id
    ami_id = data.aws_ami.devops_ami.id
}