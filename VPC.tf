# Create a VPC
resource "aws_vpc" "jena-iac-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "jena-iac-vpc"
  }
}

# Create 2 Pblic Subnet, 2 Private Subnet
resource "aws_subnet" "jena-Public-SN-1" {
  vpc_id     = aws_vpc.jena-iac-vpc.id
  availability_zone = "ap-northeast-2a"
  cidr_block = "10.10.8.0/22"

  tags = {
    Name = "jena-Public-SN-1"
  }
}

resource "aws_subnet" "jena-Public-SN-2" {
  vpc_id     = aws_vpc.jena-iac-vpc.id
  availability_zone = "ap-northeast-2c"
  cidr_block = "10.10.16.0/22"

  tags = {
    Name = "jena-Public-SN-2"
  }
}

resource "aws_subnet" "jena-Private-SN-1" {
  vpc_id     = aws_vpc.jena-iac-vpc.id
  availability_zone = "ap-northeast-2a"
  cidr_block = "10.10.24.0/22"

  tags = {
    Name = "jena-Private-SN-1"
  }
}

resource "aws_subnet" "jena-Private-SN-2" {
  vpc_id     = aws_vpc.jena-iac-vpc.id
  availability_zone = "ap-northeast-2c"
  cidr_block = "10.10.32.0/22"

  tags = {
    Name = "jena-Private-SN-2"
  }
}

# Create a Internet Gateway
resource "aws_internet_gateway" "jena-igw" {
  vpc_id = aws_vpc.jena-iac-vpc.id

  tags = {
    Name = "jena-igw"
  }
}

/*
// connect nat gateway
resource "aws_route" "private3" {
  route_table_id            = aws_route_table.Jena-Public-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.jena-igw.id
}*/


# Create a Public Route Table
resource "aws_route_table" "Jena-Public-RT" {
  vpc_id = aws_vpc.jena-iac-vpc.id
  tags = {
    Name = "Jena-Public-RT"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.jena-Public-SN-1.id
  route_table_id = aws_route_table.Jena-Public-RT.id
}

resource "aws_route_table_association" "pubic2" {
  subnet_id      = aws_subnet.jena-Public-SN-2.id
  route_table_id = aws_route_table.Jena-Public-RT.id
}

resource "aws_route" "public3" {
  route_table_id            = aws_route_table.Jena-Public-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.jena-igw.id
}

# Create a Private Route Table
resource "aws_route_table" "Jena-Private-RT" {
  vpc_id = aws_vpc.jena-iac-vpc.id
  tags = {
    Name = "Jena-Private-RT"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.jena-Private-SN-1.id
  route_table_id = aws_route_table.Jena-Private-RT.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.jena-Private-SN-2.id
  route_table_id = aws_route_table.Jena-Private-RT.id
}




