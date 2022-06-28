
variable "environment" {
  type = string
  default = "test"
}

variable "vpc_cidr" {
  type = string
  default = "172.16.0.0/16"
}

variable "instance_size" {
  type = string
  default = "t3.micro"
}

variable "instance_az" {
  type = string
  default = "eu-west-1a"
}
