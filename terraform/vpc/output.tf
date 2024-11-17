
output "public_subnet" {
    value = aws_subnet.public_subnet.id
}

output "monitor_subnet" {
    value = aws_subnet.monitor_subnet.id
}

output "vpc_id" {
    value = aws_vpc.my_vpc.id
  
}

