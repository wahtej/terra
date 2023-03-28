
# Create the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Create the subnets in the VPC
resource "aws_subnet" "my_subnets" {
  count = length(var.subnet_cidr_blocks)
  cidr_block = var.subnet_cidr_blocks[count.index]
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = var.subnet_names[count.index]
  }
}
# Create an internet gateway for the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "public-rt"
  }
}
# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_rta" {
  count = length(var.subnet_cidr_blocks)

  subnet_id = aws_subnet.my_subnets[0].id
  route_table_id = aws_route_table.public_rt.id
}

# Create a security group for the VPC
resource "aws_security_group" "my_sg" {
  name_prefix = "my-sg"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.my_subnets[0].id

  tags = {
    Name = "my-nat-gateway"
  }
}
# Create a route table for the private subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-rt"
  }
}
















