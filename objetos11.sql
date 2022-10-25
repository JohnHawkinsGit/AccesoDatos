Modelo lógico para una base de datos relacional

drop table lineasventas cascade constraints;
drop table ventas cascade constraints;
drop table telefonos cascade constraints;
drop table productos;
drop table cliente;

create table cliente(
	idcliente number primary key,
	nombre varchar(50),
	direccion varchar(50),
	poblacion varchar(50),
	cdopostal varchar(20),
	provincia varchar(40),
	nif varchar(9) NOT NULL
);	
create table telefonos(
	idcliente number,	
	telefono number,
	constraint pk_idcliente_tel primary key (idcliente,telefono),
	constraint fk_idclientes foreign key (idcliente) references cliente(idcliente)
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
	constraint fk_idcliente foreign key (idcliente) references cliente(idcliente)
);	

create table lineasventas(
	idventas number,
	numerolinea number,
	idproducto number,
	cantidad number,
	constraint pk_idventas_linea primary key (idventas,numerolinea),
	constraint fk_idventas foreign key (idventas) references ventas(idventas),
	constraint fk_idproducto foreign key (idproducto) references productos(idproducto)
);

insert into cliente values(1,'Luis Garcia','calle Las Flores,23','Guadalajara','19003','Guadalajara','34343434L');
insert into cliente values(2,'Ana Serrano','calle
Galiana,6','Guadalajara','19004','Guadalajara','76767667F');

insert into telefonos values(1,949876655);
insert into telefonos values(1,949876656);
insert into telefonos values(2,94980009);

insert into productos values(1,'caja de cristal de murano',200,10);
insert into productos values(2,'bicicleta city',120,15);
insert into productos values(3,'100 lapices de colores',20,5);
insert into productos values(4,'ipad',600,5);
insert into productos values(5,'ordenador portatil',400,10);


-- 2. Diseña el modelo objeto-relacional
drop type tip_venta;
drop type tip_lineas_venta;
drop type tip_linea_venta;
drop type tip_producto;
drop type tip_cliente;
drop type tip_direccion;
drop type tip_telefonos;


create or replace type tip_telefonos as table of varchar2(15);
/
create or replace type tip_direccion as object(
    calle varchar2(50),
    poblacion varchar2(50),
    codpos varchar2(20),
    provincia varchar2(40)
);
/

create or replace type tip_cliente as object(
    idcliente number,
    nombre varchar2(50),
    direc tip_direccion,
    nif varchar2(9),
    telef tip_telefonos
);
/

create or replace type tip_producto as object(
    idproducto number,
    descripcion varchar2(80),
    pvp number,
    stockactual number
);
/

create or replace type tip_linea_venta as object(
    numerolinea number,
    idproducto ref tip_producto,
    cantidad number
);
/

create or replace type tip_lineas_venta as table of tip_linea_venta;
/
create or replace type tip_venta as object(
    idventa number,
    idcliente ref tip_cliente,
    fechaventa date,
    lineas tip_lineas_venta,
    member function total_venta return number
);
/	
