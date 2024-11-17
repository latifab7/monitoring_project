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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC46Sxi9W+AwBvO9KS3u1QCetZt3SXbwgKdl8UyNXG9C1WBqluL3aWvTaIL3S2O16NXEsLqUG85+N7/sVWSbjiT0ctFGTet6Gv8E6q7t5mjVS0Fzxguls66Ua9xJ26ZsVlB7Tz5kWAK8dHvSsPEL8YmdL6kUCPkB6Ip9CmNMPK8nny8Oj/wUwIOnpo/LrnBwu8uKSf+1l0HC+k4eV7so6ZBrh16nsh8hGg6n0DglLQ1mogYswfKukxeau31cvS7gMFf7JQ2UIGOgZ1lRZAMtxNXWMkc4PqCrT5CJMmkk8Q5Zx+s3NCc+AYm+J+/cPC7Wv6o5EPp49ZoBc8qmoTIui0GbLoOFHo+gwBhsIfOY7scNm40Ac9EMPwcWz9E35c+kZMtxUYTCQ8r63pAD3ps7kj2E8w/cMWJ1B4hoVtgQlvY7+fDUb+kztFXsGM1lux4d4pTuMg5wA7PNOdRmyGbO0AG1KuyRol0hIG+5vtPz3XmIHsFQmZ7aKTU+GtWrjZtTn30siX08krL+IZVCGVbUa2zPaScCRfqOpssxMnREIwv5+3imiiFWDx02sK5EdcWLAQSzLPJ69OXUK4udiyoIlCIHiD6/AAY9cN4xv6fpNEylth4W4fQnsQQxbOQJ65XnpPuj93Y0wpgRGw0p0uBOtQaljkGpJ2dG8aLYLaR0UuwBw== latifa@debian"
}
