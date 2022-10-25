Modelo lógico para una base de datos relacional

drop table lineasventas on cascade;
drop table ventas on cascade;
drop table productos;
drop table cliente;

create table cliente(
	idcliente number primary key,
	nombre varchar(50),
	direccion varchar(50),
	poblacion varchar(50),
	cdopostal varchar(20),
	provincia varchar(40),
	nif varchar(9) NOT NULL,
	tel1 number,
	tel2 number,
	tel3 number
);

create table productos(
	idproducto number primary key,
	descripcion varchar(80),
	pvp number,
	stockactual number default 0
);	
	
create table ventas(
	idventas number primary key,
	idcliente number, 
	fechaventa date default sysdate,
	constraint fk_idcliente foreign key idcliente references cliente(idcliente)
);	

create table lineasventas(
	idventas number,
	numerolinea number,
	idproducto number,
	cantidad number,
	constraint pk_idventas_linea primary key (idventas,numerolinea),
	constraint fk_idventas foreign key idventas references ventas(idventas),
	constraint fk_idproducto foreign key idproducto references productos(idproducto)
);
	
