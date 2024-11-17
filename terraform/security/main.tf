# dont forget to add ssh key and delete it from web module

####################################
# SECURITY GROUPS
####################################

# TEST INSTANCE
resource "aws_security_group" "public_sg" {
  name = "public_sg"
  description = "Security Group for our test_instance"                   
  vpc_id = var.vpc_id

  egress {
    description = "allow all traffic out"
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "public_sg"
  }
}

# MONITORING INSTANCE
resource "aws_security_group" "monitor_sg" {
  name = "monitor-sg"
  description = "Security Group for our monitor Instance"
  vpc_id = var.vpc_id

  egress {
    description = "allow all traffic out"
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "monitor_sg"
  }
}


##############################
# PUBLIC SECURITY GROUP RULES
##############################

resource "aws_security_group_rule" "public_ingress_ssh" {
  type = "ingress"
  description = "Allow SSH connection"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [var.trusted_ip] # from personal/professional IP only 
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "public_ingress_https" {
  type = "ingress"
  description = "Allow https traffic "
  from_port = var.https_port
  to_port = var.https_port
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "public_ingress_http" {
  type = "ingress"
  description = "Allow http traffic "
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "public_ingress_metrics" {
  type = "ingress"
  description = "Allow Node exporter metrics collection from monitoring instance "
  from_port = var.metrics_port
  to_port = var.metrics_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.monitor_sg.id # from monitor sg
  security_group_id = aws_security_group.public_sg.id # attach to public sg
}


##############################
# MONITOR SG RULES
##############################

resource "aws_security_group_rule" "monitor_ingress_https" {
  type = "ingress"
  description = "Allow https for secure grafana access"
  from_port = var.https_port
  to_port = var.https_port
  protocol = "tcp"
  cidr_blocks = [var.trusted_ip]
  security_group_id = aws_security_group.monitor_sg.id
}


resource "aws_security_group_rule" "monitor_ingress_http" {
  type = "ingress"
  description = "allow traffic for ssh certificate validation " # to delete once ssl certif is approuved
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.monitor_sg.id
}

# to disable if nginx configuration works
resource "aws_security_group_rule" "monitor_ingress_prometheus" {
  type = "ingress"
  description = "Allow prometheus access"                
  from_port = 9090                  # try to configure via nginx for better safety
  to_port = 9090
  protocol = "tcp"
  cidr_blocks = [var.trusted_ip]
  security_group_id = aws_security_group.monitor_sg.id
}

# to disable if nginx configuration works
resource "aws_security_group_rule" "monitor_ingress_grafana" {
  type = "ingress"
  description = "Allow grafana access"                
  from_port = 3000   # try to configure via nginx for better safety
  to_port = 3000
  protocol = "tcp"
  cidr_blocks = [var.trusted_ip]
  security_group_id = aws_security_group.monitor_sg.id
}


resource "aws_security_group_rule" "monitor_egress_metrics" {
  type = "egress"
  description = "allow outbound traffic for metrics scraping"
  from_port = var.metrics_port
  to_port = var.metrics_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.public_sg.id
  security_group_id = aws_security_group.monitor_sg.id
}

