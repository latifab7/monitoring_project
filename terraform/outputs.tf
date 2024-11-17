output "test_ip" {
    description = "print test_intance Ip to update dns"
    value = module.web.test_Ip
}

output "monitor_ip" {
    description = "print monitoring Ip to update dns"
    value = module.web.MonitoringIp
}
