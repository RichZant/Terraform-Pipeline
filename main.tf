resource "aws_vpc" "Richard" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Richard-VPC"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.Richard.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "terraform-subnet-1"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.Richard.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "terraform-subnet-2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Richard.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "rte" {
  vpc_id = aws_vpc.Richard.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "terraform-rte"
  }
}

resource "aws_route_table_association" "asso" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rte.id
}

resource "aws_instance" "web" {
  ami           = "ami-02396cdd13e9a1257"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.sub1.id

  tags = {
    Name        = "terraform-instance"
  }
}