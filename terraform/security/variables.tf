##############################
# VARIABLE FROM OTHER MODULES
###############################

variable "vpc_id" {
    description = "vpc id"
    type = string
}


##############################
# VARIABLE FROM THIS MODULE
###############################
variable "trusted_ip" {
    description = "MY IP ADRESS"
    type = string 
}

variable "metrics_port" {
    description = "metrics port"
    type = number
    default = 9100 
}

variable "https_port" {
    description = "https port"
    type = number 
    default = 443
  
}

variable "prometheus" {
    description = "prometheus port"
    type = number 
    default = 9090
  
}

