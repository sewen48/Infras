provider "aws" {
  region = "us-east-1" # Change to your desired region
  profile   = "sanni"
}

# Create VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support  = true
  enable_dns_hostnames = true

  tags = {
    Name = "custom_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom_igw"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

# Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "public_route_table"
  }
}

# Create Route to Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Create Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic on ports 80, 443, and 22"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "web_sg"
  }
}
