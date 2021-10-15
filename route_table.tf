#tabela de rotas acesso publico
resource "aws_route_table" "djl_rota_publica" {
  vpc_id = aws_vpc.vpc_djl.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_djl.id

  }
  tags = {
    Name = "public-djl"
  }
}

#Associando a subnet 10.0.0.0/24 a rota pública
resource "aws_route_table_association" "pub_1a" {
  subnet_id      = aws_subnet.public_djl_1a.id
  route_table_id = aws_route_table.djl_rota_publica.id
}

#Associando a subnet 10.0.1.0/24 a rota pública
resource "aws_route_table_association" "pub_1c" {
  subnet_id      = aws_subnet.public_djl_1c.id
  route_table_id = aws_route_table.djl_rota_publica.id
}

#======================================= Rotas Privadas AZ(us-east-1a) ====================================
resource "aws_route_table" "djl_rota_app" {
  vpc_id = aws_vpc.vpc_djl.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_djl_1a.id
  }
  tags = {
    Name = "private-api-djl"
  }
}

#Associando a subnet 10.0.4.0/24 a rota privada
resource "aws_route_table_association" "ap_1a" {
  subnet_id      = aws_subnet.privateapp_djl_1a.id
  route_table_id = aws_route_table.djl_rota_app.id
}

#Associando a subnet 10.0.6.0/24 a rota privada
resource "aws_route_table_association" "db_1a" {
  subnet_id      = aws_subnet.privatedb_djl_1a.id
  route_table_id = aws_route_table.djl_rota_app.id
}

#======================================= Rotas Privadas AZ(us-east-1c) ====================================
resource "aws_route_table" "djl_rota_db" {
  vpc_id = aws_vpc.vpc_djl.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_djl_1c.id
  }
  tags = {
    Name = "private-db-djl"
  }
}

#Associando a subnet 10.0.5.0/24 a rota privada
resource "aws_route_table_association" "ap_1c" {
  subnet_id      = aws_subnet.privateapp_djl_1c.id
  route_table_id = aws_route_table.djl_rota_db.id
}

#Associando a subnet 10.0.7.0/24 a rota privada
resource "aws_route_table_association" "db_1c" {
  subnet_id      = aws_subnet.privateapp_djl_1c.id
  route_table_id = aws_route_table.djl_rota_db.id
}
