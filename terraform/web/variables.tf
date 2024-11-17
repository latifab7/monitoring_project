####################################
# VARIABLE FROM OTHER MODULE
#####################################


variable "public_sg" {
    description = "securtity group's id for our test_instance"
    type = string
}

variable "monitor_sg" {
    description = "security group's id for our monitor instance"
    type = string
}

variable "public_subnet" {
    description = "Public Subnet Id"
    type = string
}

variable "monitor_subnet" {
    description = "Monitor Subnet Id"
    type = string
  
}

####################################
# VARIABLE FROM THIS MODULE
#####################################

variable "instance_image" {
    description = "Image Id "
    type = string
    default = "ami-0359cb6c0c97c6607"
}

variable "instance_type" {
    description = "Instance Type - free tiers"
    type = string
    default = "t2.micro"
}

variable "environment" {
    description = "which environment production or pre "
    type = string
    default = "production"
}


