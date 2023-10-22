module "catalogue_dev" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  name = "${var.projectname}-${var.env}-catalogue"
    ami = "${local.ami_id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
   subnet_id              = local.private_cidr_block[0]
   //user_data = file("./user.sh")
    instance_tags = merge({
        "Name" = "${var.projectname}-${var.env}-catalogue"
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

resource "aws_ec2_instance_state" "stopping" {
  instance_id = module.catalogue_dev.id
  state       = "stopped"
  depends_on = [ null_resource.execute_script ]
}

resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "catalogue_dev_ami-${local.current_time}"
  source_instance_id = module.catalogue_dev.id
  depends_on = [ aws_ec2_instance_state.stopping ]

}

# resource "aws_ec2_instance_state" "starting" {
#   instance_id = module.catalogue_dev.id
#   state       = "running"
# }

resource "null_resource" "terminate_catalogue" {

    triggers ={
        ami_id = aws_ami_from_instance.catalogue_ami.id
    }



  provisioner "local-exec" {
   command = "aws ec2 terminate-instances --instance-ids ${module.catalogue_dev.id}"
  }
}


resource "aws_launch_template" "catalogue" {
  name = "${var.projectname}-${var.env}-catalogue"

  image_id = aws_ami_from_instance.catalogue_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.projectname}-${var.env}-catalogue-launch-template"
    }
  }

  //user_data = filebase64("${path.module}/catalogue.sh")
}


resource "aws_autoscaling_group" "catalogue_autoscaling_grp" {
  name                      = "${var.projectname}-${var.env}-catalogue-autoscaling-grp-${local.current_time}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 660
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  target_group_arns = [aws_lb_target_group.catalogue_tg.arn]
  launch_template{
    id = aws_launch_template.catalogue.id
    version = "$Latest"
  }
  vpc_zone_identifier       = local.private_cidr_block
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "catalogue-policy" {
  autoscaling_group_name = aws_autoscaling_group.catalogue_autoscaling_grp.name
  name                   = "${var.projectname}-${var.env}-catalogue-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20
    
  }
}
resource "aws_lb_target_group" "catalogue_tg" {
  name     = "${var.projectname}-${var.env}-catalogue-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.roboshop_vpcid.value
  deregistration_delay = 60
   health_check {
    enabled = true
    path                = "/health"  # The path to check on the instances
    port                = "8080"       # The port to use for the health check
    protocol            = "HTTP"     # The protocol to use for the health check
    interval            = 30         # The interval between health checks (in seconds)
    timeout             = 5          # The amount of time to wait for a response (in seconds)
    healthy_threshold   = 2          # Number of consecutive successful checks for an instance to be considered healthy
    unhealthy_threshold = 2          # Number of consecutive failed checks for an instance to be considered unhealthy
    matcher = "200-299"
  }
}

# resource "aws_lb_target_group_attachment" "catalogue_tg_attachment" {
#   target_group_arn = aws_lb_target_group.catalogue_tg.arn
#   target_id        = aws_autoscaling_group.catalogue_autoscaling_grp.id
  
# }

# resource "aws_lb_target_group_attachment" "example" {

#   target_group_arn = aws_lb_target_group.catalogue_tg.arn
#   target_id        = aws_lb.app_alb.id
#   port             = 8080
# }

resource "aws_lb_listener_rule" "static" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 90

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue_tg.arn
  }

  # condition {
  #   path_pattern {
  #     values = ["categories"]
  #   }
  # }

  condition {
    host_header {
      values = ["catalogue.app-dev.saikiransudhireddy.com"]
    }
  }
}