variable "vpc_cidr" {
    description = "cidr block for vpc"
    type = string
}

variable "public_cidr" {
    description = "cidr block for public subnet"
    type = string
}

variable "monitor_cidr" {
    description = "cidr block for monitor subnet"
  
}

variable "environment" {
    description = "Environment type"
    type = string
    default = "production"
}
