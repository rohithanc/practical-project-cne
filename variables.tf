variable "subnetA_id" {
  default = "subnet-81f1f4e7"
}

variable "subnetB_id" {
  default = "subnet-861b0fce"
}

variable "security_group_ids" {
  default = "sg-fa440dbc"
}

variable "username" {
  description = "Username needed to log in to RDS"
}

variable "password" {
  description = "Password needed to log in to RDS"
}
