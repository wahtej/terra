# creating aws custom vpc
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

# creating custom vpc name
variable "vpc_name" {
  description = "Name of the VPC"
  default = "my-vpc"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for the subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "subnet_names" {
  description = "Names for the subnets"
  type = list(string)
  default = ["public-subnet","private1-subnet", "private2-subnet"]
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1a"]
}







