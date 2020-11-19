provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
}

resource "aws_db_instance" "test" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "test_db"
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.security_group_ids]
  skip_final_snapshot    = true
  identifier             = "cne-testdb"
}

resource "aws_db_instance" "production" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "production_db"
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.security_group_ids]
  skip_final_snapshot    = true
  identifier             = "cne-productiondb"
}

resource "aws_db_subnet_group" "default" {
  name       = "db_subnet_group"
  subnet_ids = [var.subnetA_id, var.subnetB_id]

  tags = {
    Name = "Database Subnet"
  }
}

