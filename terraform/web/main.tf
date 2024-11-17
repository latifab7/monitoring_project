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
        Name = "web_${var.environment}"
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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCX1JCM6Zii0aXKA5hP8dnNA8NBCc6ihyeyjtM3igWIfDecVZPsNWvaQ7qrevTehvAJvt2qgCAdTIuI/nicjTZCje8KPg+v2OUbnB1MME7u8h4eANf16L2oSD66xo0Azpjahbrr0oFvGWL61cKgYyACcEvAhUsTgZGC6ZKatxOUb9cMRtnjtkpxycVOj0D5QASld2x6vBFbuA3YSRe7uLp+duZhZgxw2HxQ3CoIxZZIAfjQ7hDO6GEuLHAwMcnILqIZKyBTJSKrZbgRpGm/r/cPcOkkfjmpEonzfgwjefBsc6710pifTFiZXS6SsELpr/+nxYe90TNFpCfqzSO1dbbeffgoFI5t9UH21GBgEY/nOMjX++VdzUl/S58AR+CiutrPK1KtAWxpgaDQvpN/2v4B9Rq4OzmCxvZKXm0EG0/S/Wxag1qQJJGW5i+CA5hZqqp0pdbp8Ow4gzemLrOlXXhXqgc1bujd04RRBk4Meoy47qogVwq7sl47X7syF0Gjq2MHQUeZxOE6pP8breA8CTaNEftv8YXKPZslxKimLRQXXBeAqMXLiyGLU3wLSGRFwFc6ik0RVKJ/nUazagkZNPT01HpHkre+RbrKJ1W2E5kNJHui8DfGvhkL68FFIuTBL8YVPTwMLPFMADqeIqvgDw+oRywEUM+1JA3/pIqvpj8eaQ== engineer@debian"
}
