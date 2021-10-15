resource "aws_internet_gateway" "igw_djl" {
  vpc_id = aws_vpc.vpc_djl.id

  tags = {
    Name = "igw_djl"
  }
}