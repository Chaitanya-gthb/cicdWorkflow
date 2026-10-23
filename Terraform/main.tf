data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "testVpc-1"
  }
}

# Public Subnet
resource "aws_subnet" "pubsub" {
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.0.0.0/27"

  tags = {
    Name = "pubsub-1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "testIgw-1"
  }
}

# Public Route Table
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "pubrt-1"
  }
}

# Public Route
resource "aws_route" "route-pub" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.pubrt.id
  gateway_id             = aws_internet_gateway.igw.id
}

# Public Route Table Association
resource "aws_route_table_association" "pub_assoc" {
  subnet_id      = aws_subnet.pubsub.id
  route_table_id = aws_route_table.pubrt.id
}

# Public Security Group
resource "aws_security_group" "pub-sg" {
  name        = "pub-sg"
  description = "Allow http and ssh traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pubSg-1"
  }
}

# Public EC2 Instance
resource "aws_instance" "my_ec2_1" {
  ami                         = data.aws_ami.linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.pubsub.id
  security_groups             = [aws_security_group.pub-sg.id]
  associate_public_ip_address = true

  user_data = file("./user_data.sh")

  tags = {
    Name = "testPubEc2-1"
  }
}