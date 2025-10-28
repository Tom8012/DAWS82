provider "aws" {
  region = "ap-south-1"  # Change to your region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Create a subnet inside the VPC
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"  # Change based on your region
   map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
  }
}

# Create an internet gateway to allow internet access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a route table for the subnet with a default route to the internet gateway
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main-route-table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Security Group to allow all inbound/outbound (adjust as needed)
resource "aws_security_group" "allow_all_docker" {
  name        = "allow_all_docker"
  description = "Allow all inbound/outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow_all_docker"
  }
}
# EC2 instance inside the subnet
resource "aws_instance" "this" {
  ami                    = "ami-02d26659fd82cf299"  # Amazon Linux 2 in us-east-1, change if needed
  instance_type          = "t3.micro"
  key_name               = "test2" 
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_all_docker.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name = "num-instance"
  }
}

# Output the public IP
output "docker_ip" {
  value = aws_instance.this.public_ip
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}