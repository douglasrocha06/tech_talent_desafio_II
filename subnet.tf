#====================================CRIAÇÃO DE 2 SUBNETS PÚBLICAS ======================================
resource "aws_subnet" "public_djl_1a" {
  vpc_id                  = aws_vpc.vpc_djl.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public_djl_1a"
  }
}

resource "aws_subnet" "public_djl_1c" {
  vpc_id                  = aws_vpc.vpc_djl.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"
  tags = {
    Name = "public_djl_1c"
  }
}
#=================================CRIAÇÃO DE 4 SUBNETS PRIVADAS (2 APP, 2 BD)===============================
resource "aws_subnet" "privateapp_djl_1a" {
  vpc_id            = aws_vpc.vpc_djl.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "privateapp_djl_1a"
  }
}

resource "aws_subnet" "privateapp_djl_1c" {
  vpc_id            = aws_vpc.vpc_djl.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "privateapp_djl"
  }
}

resource "aws_subnet" "privatedb_djl_1a" {
  vpc_id            = aws_vpc.vpc_djl.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "privatedb_djl_1a"
  }
}

resource "aws_subnet" "privatedb_djl_1c" {
  vpc_id            = aws_vpc.vpc_djl.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "privatedb_djl_1c"
  }
}