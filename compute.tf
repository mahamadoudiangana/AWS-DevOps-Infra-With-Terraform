resource "aws_key_pair" "instances-key" {
  key_name   = "instances-key"
  public_key = file("./instances-key.pub")
}


# 7. Launching EC2 Instances with Security Groups

# 7.1. Public EC2 Instance in the public subnet
resource "aws_instance" "bastion-server" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = aws_key_pair.instances-key.key_name
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public-subnet_sg.id]

  tags = {
    Name = "bastion-server"
  }

}

resource "aws_instance" "web-server" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = aws_key_pair.instances-key.key_name
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public-subnet_sg.id]

  # Let's extract the content of userdata.tpl and run its contains in the ec2 instance terminal during its creation
  user_data = file("web_server_userdata.sh")

  tags = {
    Name = "web-server"
  }
}


# 7.2. Private EC2 Instance in the private subnet
# Let's start 3 CE2 instances as worker nodes in the private and see if our security group rules are well applied
resource "aws_instance" "database-server" {
  count           = 3
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = aws_key_pair.instances-key.key_name
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private-subnet_sg.id]

  lifecycle { 
    create_before_destroy = true
  }

  # Let's extract the content of userdata.tpl and run its contains in the ec2 instance terminal during its creation
  user_data = file("application_servers_userdata.sh")
  tags = {
    Name = "database${count.index + 1}"
  }
}
