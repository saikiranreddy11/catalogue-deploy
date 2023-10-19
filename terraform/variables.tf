variable "vpc_cidr_block"{
    default = "10.0.0.0/16"

}
variable "projectname"{
    default ="roboshop"
}
variable "common_tags"{
    default={
    project = "roboshop"
    environment = "development"
    terraform = "true"
    }
}

variable "vpc_tags"{
    type = map
    default = {
    Name = "roboshop"
    }
}

variable "enable_dns_hostnames"{
    default = "true"
}

variable "enable_dns_support"{
    default = "true"   
}

variable "gw_tags"{
    type = map
    default = {
    Name = "roboshop"
    }
}

# variable "az"{
#     
# }

variable "public_cidr_block"{
    default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_cidr_block"{
    default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "database_cidr_block"{
    default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "sg_name"{
    default = "Roboshop"
}
variable "sg_description"{
    default = "Dummy description"
}


variable "ingress_rules"{
    default = [
        {
    description      = "Inbound rule to allow HTTPS traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    
        }
    #     {
    # description      = "Inbound rule to allow HTTP traffic"
    # from_port        = 80
    # to_port          = 80
    # protocol         = "tcp"
    # cidr_blocks      = ["0.0.0.0/0"]

    #     },
    #     {
    # description      = "Inbound rule to allow SSH traffic"
    # from_port        = 22
    # to_port          = 22
    # protocol         = "tcp"
    # cidr_blocks      = ["0.0.0.0/0"]
    #     }
    ]
}

variable "instances"{
    default ={
        "web" = "t2.micro"
        "catalogue" = "t2.micro"
        "user" = "t2.micro"
        "cart" = "t2.micro"
        "payment" = "t2.micro"
        "shipping" = "t2.micro"
        "redis" = "t2.micro"
        "rabbitmq" = "t2.micro"
        "mongodb" = "t3.medium"
        "mysql" = "t3.medium"

    }
}