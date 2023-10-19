module "sg" {
    source= "../terraform-SG-module"
    ingress_rules = var.ingress_rules
    sg_name = var.sg_name
    sg_description = var.sg_description 
    vpc_id = local.vpc_id
    common_tags = var.common_tags
    projectname = var.projectname
}