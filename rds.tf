#instancia rds
resource "aws_db_instance" "djlbanco" {
  allocated_storage      = 10
  max_allocated_storage  = 11
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "djlbanco"
  username               = "admin"
  password               = "12345678"
  db_subnet_group_name   = aws_db_subnet_group.djl_dbgroup.id
  vpc_security_group_ids = [aws_security_group.sg_db_djl.id, aws_security_group.sg_ssh_djl.id]
  skip_final_snapshot    = true
  multi_az   = true
  identifier = "djlbanco"
  tags = {
    Name = "djlbanco"
  }
}

#grupo rds - configuração das subnets
resource "aws_db_subnet_group" "djl_dbgroup" {
  name       = "djl_dbgroup"
  subnet_ids = [aws_subnet.privatedb_djl_1a.id, aws_subnet.privatedb_djl_1c.id]

  tags = {
    Name = "djl_dbgroup"
  }
}