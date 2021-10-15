resource "aws_eip" "djl_ELPnat1a" {
  depends_on = [aws_internet_gateway.igw_djl]

  tags = {
    Name = "djl_ELPnat1a"
  }
}
resource "aws_eip" "djl_ELPnat1c" {
  depends_on = [aws_internet_gateway.igw_djl]

  tags = {
    Name = "djl_ELPnat1c"
  }
}
