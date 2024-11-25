##################################
# EC2 INSTANCES
#################################

# INSTANCE TO BE MONITOR
resource "aws_instance" "test_instance" {
    ami = var.instance_image
    instance_type = var.instance_type
    subnet_id = var.public_subnet      

    security_groups = [var.public_sg] # var.public_sg
    key_name = "terraform-aws"

    tags = {
        Name = "test_${var.environment}"
    }
}


# MONITORING INSTANCE
resource "aws_instance" "monitoring" {
    ami = var.instance_image
    instance_type = var.instance_type
    subnet_id = var.monitor_subnet
    security_groups = [var.monitor_sg] # var.monitor_sg
    key_name = "terraform-aws"

    tags = {
        Name = "monitoring"
    }
}


##################################################
# ANSIBLE HOST FILE CREATION  
#################################################


# ansible hosts file creation
resource "null_resource" "hosts" {
  depends_on = [ aws_instance.test_instance, aws_instance.monitoring ] 
  triggers = {
    time = "${timestamp()}"
  }
  count = 1 
  provisioner "local-exec" {
    command = <<-EOT
      echo [test_instance] >> ./hosts
      echo ${element(aws_instance.test_instance[*].public_ip, count.index)} >> ./hosts
    EOT
    when = create
  }
  provisioner "local-exec" {
    command = <<-EOT
      echo [monitoring] >> ./hosts
      echo ${element(aws_instance.monitoring[*].public_ip, count.index)} >> ./hosts
    EOT
    when = create
  }
  provisioner "local-exec" {
    command = "rm -f ./hosts" # delete the host file when terraform destroy
    when = destroy
  }
}


# create ssh key to be attached to the ec2 instance 
resource "aws_key_pair" "ssh-key" {
    key_name = "terraform-aws"
    public_key = "ENTER YOUR PUBLIC KEY HERE"
}