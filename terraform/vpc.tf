#VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "opsschool_vpc"
  }
}

#PUBLIC SUBNET

resource "aws_subnet" "public_subnet" {
  count = length(var.az)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[count.index]
  availability_zone = var.az[count.index]
  tags = {
    Name = "public_subnet-${count.index+1}"
  }
}

#PRIVATE SUBNET

resource "aws_subnet" "private_subnet" {
  count = length(var.az)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[count.index]
  availability_zone = var.az[count.index] 
  tags = {
    Name = "private_subnet-${count.index+1}"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet_gateway"
  }
}

#NAT-GW

resource "aws_nat_gateway" "gw" {
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "Public NAT GW"
  }
}

#Route Tabels (Proper routes)

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public routes"
  }
}

resource "aws_route_table_association" "routes_to_public_subnet1" {
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "routes_to_public_subnet2" {
  subnet_id      = aws_subnet.public_subnet[1].id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table" "private_routes" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "172.31.37.238"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "private routes"
  }
}

resource "aws_route_table_association" "routes_to_private_subnet1" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_routes.id
}

resource "aws_route_table_association" "routes_to_private_subnet2" {
  subnet_id      = aws_subnet.private_subnet[1].id
  route_table_id = aws_route_table.private_routes.id
}