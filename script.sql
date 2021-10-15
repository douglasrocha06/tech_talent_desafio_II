/*================================Clientes======================================*/
create database api_clientes;

use api_clientes;

create table clientes(
	id int not null auto_increment primary key,
	nome varchar(100) not null,
	cpf  int(11),
    nascimento date,
    email varchar(100)
    )default charset=utf8;
        
insert	into clientes values
	(default,'Douglas Cristhian','10625716655','1999-08-06','douglas.rocha6@hotmail.com'),
    (default,'Matheus','76954371359','1999-10-17','matheus.oliveira@hotmail.com'),
    (default,'Marcos','10648316595','1999-11-04','marcos.silva@hotmail.com'),
    (default,'Lucas','12340785644','1978-12-02','lucas.rodrigues@hotmail.com');

    create table enderecos (
	idEndereco int(11) primary key auto_increment,
    rua varchar(100) not null,
    numero int (10) not null,
    complemento varchar(100), 
    bairro varchar (100) not null,
    cidade varchar (100) not null,
    estado varchar (100) not null,
    cep varchar (8) not null,
    idCliente int(11),
	foreign key(idCliente) references enderecos(idEndereco)
   )default charset=utf8;

insert into enderecos (rua, numero, complemento, bairro, cidade, estado, cep, idCliente) values
	('Rua Souza','76','','Jd Cruzeiro','Bahia','BA','09852765', 1),
	('Av. Parada','62','','Vila Silveira','Distrito Federal','DF','02766547', 1),
	('Rua Antonio ','65','','Franco','Paraiba','PB','02769873', 2),
	('Rua Souto','346','Viela 1','Caboia','Roraima','RR','02761963', 2),
	('Av. Melo','43','7 Andar','Pedra Sapopemba','Pernambuco','PE','65754765',3),
	('Rua Yara','32','Casa 3','Parapua','Rio de Janeiro','RJ','98766756',3);
    
/*================================Catalogo======================================*/    
create database api_produtos;

use api_produtos;

create table catalogo (
	id_produtos int(11) primary key auto_increment,
    produtos varchar(100) not null,
	preco real not null,
    estado varchar(100) not null,
	qtd_estoque	int(11) not null,
    tamanho enum ('PP', 'P', 'M', 'G', 'GG', 'XG') not null,
    genero enum('M', 'F') not null
)default charset=utf8;

insert into catalogo(produtos, preco, estado, qtd_estoque, tamanho, genero) values
	('Legging', '29.99', 'Disponivel', '35', 'M', 'F'),
	('Moletom', '79.99', 'Indisponivel', '0', 'G', 'M'),
	('Camiseta', '69.90', 'Disponivel', '3', 'P', 'M'),
	('Regata', '29.00', 'Disponivel', '76', 'GG', 'M'),
	('Blusa', '130.80', 'Disponivel', '10', 'M', 'F'),
	('Short', '65.89', 'Indisponivel', '0', 'G', 'F'),
	('Saia', '42.99', 'Disponivel', '5', 'G', 'M');
    
create table vendas (
	id_venda int(11) primary key auto_increment,
    data_venda date,
    qtd_venda int(11),
	id_produtos int(11) not null,
    foreign key (id_produtos) references catalogo(id_produtos)
)default charset=utf8;

insert into vendas(data_venda, qtd_venda, id_produtos)values
	('2020-03-04', '10','1'),
	('2020-01-12', '3','2'),
	('2020-03-14', '2','1'),
	('2020-10-16', '6','1'),
	('2020-10-16', '6','3');
    
/*================================Inventario======================================*/
create database api_inventario;

use api_inventario;

create table inventario (
id_vendas int(11) primary key auto_increment,
id_cliente int(11),
id_produto int(11),
data_venda date
)default charset = utf8;

insert into inventario(id_vendas, id_cliente, id_produto, data_venda) values
	(default, '1', '1', '2021-05-27'),
    (default, '1', '2', '2021-06-02'),
    (default, '2', '3', '2021-10-10'),
    (default, '2', '1', '2021-07-09');