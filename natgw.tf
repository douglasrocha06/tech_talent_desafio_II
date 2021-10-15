resource "aws_nat_gateway" "nat_djl_1a" {
  allocation_id = aws_eip.djl_ELPnat1a.id
  subnet_id     = aws_subnet.public_djl_1a.id

  tags = {
    Name = "nat_djl_1a"
  }
}
resource "aws_nat_gateway" "nat_djl_1c" {
  allocation_id = aws_eip.djl_ELPnat1c.id
  subnet_id     = aws_subnet.public_djl_1c.id

  tags = {
    Name = "nat_djl_1c"
  }
}