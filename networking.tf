# 1. Create a VPC
resource "aws_vpc" "mlops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "mlops-vpc"
  }
}


# 2. Create Subnets:
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.mlops_vpc.id
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true # The map_public_ip_on_launch = true setting in the Terraform script means that any instance 
  # launched in this subnet will automatically be assigned a public IP address

  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.mlops_vpc.id
  availability_zone = var.availability_zone
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "private-subnet"
  }
}

# vpc = true: This specifies that the EIP is for use in a VPC, which is necessary for associating it with a NAT Gateway.

# 3. Create an Internet Gateway:
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mlops_vpc.id

  tags = {
    Name = "mlops-vpc-igw"
  }
}

# 4. Create a NAT Gateway
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "mlops-vpc-eip"
  }
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id # subnet_id = aws_subnet.public.id: This specifies that the NAT Gateway is deployed in a 
  # public subnet, which is necessary for it to have internet access.

  tags = {
    Name = "nat_gateway"
  }
}




# resource "aws_eip_association" "example" {
#   allocation_id = aws_eip.example.id
#   instance_id   = aws_instance.example.id
# }


# 5. Route Tables
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.mlops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id # Since it's a public subnet, the outbound traffics will go to the internet gateway
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.mlops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id # Since it's a private subnet, the outbound traffics will go to the nat gateway
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "private-route-table-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private_subnet.id
}

# 6. Security group to allow ssh access to the public subnet instances
resource "aws_security_group" "public-subnet_sg" {
  # name        = "mlops-public-subnet-sg"
  description = "Allow ssh access to instances in the public subnet"
  vpc_id      = aws_vpc.mlops_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip] # Only a traffic from my home network can ssh to the instances running in the public subnet
  }

  # Allow ICMP (ping) traffic from my home router public IP
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.my_public_ip] # We can ping the public subnet from my home router public IP

    # In the context of ICMP (Internet Control Message Protocol), which is used for network diagnostics like ping, 
    # the from_port value of 8 specifies the ICMP type for “Echo Request” (ping). 
    # The to_port value of 0 is used to cover all ICMP codes.
  }

  # Allow http (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip] # "0.0.0.0/0"
  }

  # Allow https (port 443)


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-subnet-sg"
  }
}

resource "aws_security_group" "private-subnet_sg" {
  # name        = "mlops-private-subnet-sg"
  description = "Allow ssh access to instances in the private subnet"
  vpc_id      = aws_vpc.mlops_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"] # For best and common practice, we will only accept incoming traffics to any instance in this private subnet if the traffic is comming from 
    # the public subnet "10.0.1.0/24", example: a bastion EC2 (jumping box) running 
  }

  # Allow ICMP (ping) traffic from the public subnet
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.0.1.0/24"] # We can ping the private subnet from the public subnet (bastion)

    # In the context of ICMP (Internet Control Message Protocol), which is used for network diagnostics like ping, 
    # the from_port value of 8 specifies the ICMP type for “Echo Request” (ping). 
    # The to_port value of 0 is used to cover all ICMP codes.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-subnet-sg"
  }
}
