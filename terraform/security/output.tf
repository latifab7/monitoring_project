
output "public_sg" {
  value = aws_security_group.public_sg.id
}

output "monitor_sg" {
  value = aws_security_group.monitor_sg.id
}