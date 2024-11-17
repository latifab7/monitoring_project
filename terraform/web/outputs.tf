output "test_Ip" {
    description = "print the Test instance Ip adress"
    value = aws_instance.test_instance.id
}

output "MonitoringIp" {
    description = "print the Monitoring IP adress"
    value = aws_instance.monitoring.id
}
