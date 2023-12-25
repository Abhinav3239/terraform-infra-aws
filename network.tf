<<<<<<< HEAD
#creating vpc
resource "aws_vpc" "cali-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "cali-VPC"
  }
}

#creating the subnet

resource "aws_subnet" "cali-subnet-2a" {
  vpc_id                  = aws_vpc.cali-vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "cali-subnet-1a"
  }
}

resource "aws_subnet" "cali-subnet-2b" {
  vpc_id                  = aws_vpc.cali-vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "cali-subnet-1b"
  }
}

=======
#creating vpc
resource "aws_vpc" "cali-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "cali-VPC"
  }
}

#creating the subnet

resource "aws_subnet" "cali-subnet-2a" {
  vpc_id                  = aws_vpc.cali-vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "cali-subnet-1a"
  }
}

resource "aws_subnet" "cali-subnet-2b" {
  vpc_id                  = aws_vpc.cali-vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "cali-subnet-1b"
  }
}

>>>>>>> 0ca5a3d (Initial commit)
