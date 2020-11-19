provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "eu-west-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.open_internet
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "web_sg" {
  name        = "DefaultSGWeb"
  description = "Allow SSH"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    iterator  = port
    for_each = var.inbound_port
    content {
      from_port = port.value
      protocol = "tcp"
      to_port = port.value
      cidr_blocks = [var.open_internet]
   }
  }

  egress {
    from_port   = var.outbound_port
    protocol    = "-1"
    to_port     = var.outbound_port
    cidr_blocks = [var.open_internet]
  }
}

resource "aws_key_pair" "demo_key" {
  key_name   = "project-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC08FFB+sXFENyeAext7fhTrFEpdetTEFCGCfNk/YyGrxf8jOuUwhwYiEvZmpSwaFCKjmGrIFsggM+TyOvrshT45CSxhcpNFnCiOi8sGhaAIP09D5qXgseU4tkSjqDJJL/sKgjjC+kqFMuD0E9251tepooZ713ffGiLpL5pHW2ke9OY5XhnNmeL7EEwGEcjyqiE3Garq5Xb7k+BVyYXZkjtaHNaRnBOQUVjH9jkoHBfTXMJXoPWQuD8ELuwzwxvWImh9BO4Kl2Xa8zzD1zxvvWbiqohibVLDXFrf9DNWBELYfFXW6Vm/I9/JTc9HCHIhwx19LH02TZ4EOT4xvAB4JFn ubuntu@ip-172-31-33-188"
}

resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance
  key_name                    = aws_key_pair.demo_key.key_name
  associate_public_ip_address = var.enable_public_ip
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
}
