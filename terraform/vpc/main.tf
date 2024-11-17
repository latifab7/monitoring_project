##################################
# VPC 
#################################

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr 
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "vpc_${var.environment}"

  }
}

######################################
# PUBLIC SUBNETS 
######################################


# Subnet for test_instance
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id   
    cidr_block = var.public_cidr 
    map_public_ip_on_launch = true  

    tags = {
        Name = "public_subnet_${var.environment}"
    }
}

# Subnet for monitor Instance
resource "aws_subnet" "monitor_subnet" {
    vpc_id = aws_vpc.my_vpc.id  
    cidr_block = var.monitor_cidr 
    map_public_ip_on_launch = true  

    tags = {
        Name = "monitor_subnet_${var.environment}"
    }
}


#################################
# INTERNET ACCESS
##################################

# creation un internet gateway (IGW) dans le vpc crée
resource "aws_internet_gateway" "internet_gateway_project" {
  vpc_id = aws_vpc.my_vpc.id
}

# creation d'une table de routage - TEST INSTANCE
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_project.id
  }
}

# creation d'une table de routage - MONITOR INSTANCE
resource "aws_route_table" "monitor_routetable" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_project.id
  }
}


# route table association to public subnet
resource "aws_route_table_association" "publicRTlink" {
  subnet_id = aws_subnet.public_subnet.id #associate to public subnet
  route_table_id = aws_route_table.public_routetable.id
}

# route table association to monitor subnet
resource "aws_route_table_association" "monitorRTlink" {
  subnet_id = aws_subnet.monitor_subnet.id #associate to monitor subnet
  route_table_id = aws_route_table.monitor_routetable.id
}




