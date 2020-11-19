variable "region" {
  default = "eu-west-1"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "open_internet" {
  default = "0.0.0.0/0"
}

variable "instance" {
  description = "This variable states the instance type for your EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  default = "ami-0dc8d444ee2a42d8a"
}

variable "enable_public_ip" {
  description = "Enable if EC2 instance should have public IP Address"
  default     = true
}

variable "inbound_port" {
  type = list(number)
  description = "List of ingress ports"
  default     = [22, 80, 8080]
}

variable "outbound_port" {
  description = "Port open to allow outbound connection"
  default     = 0
}
