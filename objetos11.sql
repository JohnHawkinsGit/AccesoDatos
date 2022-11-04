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

-- 3. Crea el cuerpo para la función total_venta
create or replace type body tip_venta as
	member function total_venta return number is
	   total number:=0;
	   linea tip_linea_venta;
	   product tip_producto;
begin
	for i in 1..lineas.count loop
		linea:=lineas(i);
		select deref(linea.idproducto) into product from dual;
		total:= total+ linea.cantidad * product.pvp;
	end loop;	
	return total;
	end;
end;
/

-- 4. Persiste los objetos

-- Crea la tabla tabla_clientes y modica idcliente a primary key
drop table tabla_clientes;
create table tabla_clientes of tip_cliente nested table telef store as t_telefono;
/
alter table tabla_clientes add primary key (idcliente);

-- Crea la tabla tabla_productos y modica idproducto a primary key
create table tabla_productos of tip_producto;
/
alter table tabla_productos add primary key (idproducto);

-- Crea la tabla tabla_ventas y modica idventa a primary key

create table tabla_ventas of tip_venta nested table lineas store as tlineas;
/

alter table tabla_ventas add primary key (idventa);


-- 5. Inserta los datos

insert into tabla_clientes values(1,'Luis Garcia', 
									tip_direccion('calle Las Flores,23','Guadalajara','19003','Guadalajara'),
									'34343434L',
									tip_telefonos('949876655','949876655')
								);

insert into tabla_clientes values(2,'ana Serrano', 
									tip_direccion('calle Galiana,6','Guadalajara','19004','Guadalajara'),
									'76767667F',
									tip_telefonos('94980009')
								);
insert into tabla_productos values(1, 'caja de cristal de murano',100,5);
insert into tabla_productos values(2, 'bicicleta city',120,15);
insert into tabla_productos values(3, '100 lapices de colores',20,5);
insert into tabla_productos values(4, 'ipad',600,5);
insert into tabla_productos values(5, 'ordenador portatil',400,10);

-- 6. Consultas
-- 6.1 Visualizar todas las líneas de venta para la venta id 2. 
	 select * from the(select tv.lineas from tabla_ventas tv where tv.idventa=2);

-- 6.1.2 Haz la consulta de otra forma sin sacar el nombre del objeto, usando TABLE.
	 select lin.* from tabla_ventas tv, table(tv.lineas) lin where tv.idventa=2;

-- 6.2 Visualizar todas las líneas de venta para la venta id 2, obteniendo los productos en vez de su oid.
	select deref(lin.idproducto) from tabla_ventas tv, table(tv.lineas) lin where tv.idventa=2;

-- 6.3 Visualizar todas las líneas de venta de todas las ventas.
	select deref(lin.idproducto) from tabla_ventas tv, table(tv.lineas) lin;

-- 6.4 Consulta el nombre del cliente idcliente 2
	select nombre from tabla_clientes where idcliente=2;

-- 6.5 Modifica el nombre del cliente 2 por Rosa Serrano
	update tabla_clientes set nombre='Rosa Serrano' where idcliente=2;

-- 6.6 Consulta la dirección del cliente 2 y modifica la calle por calle Estopa,34
	select tc.direc.calle from tabla_clientes tc where idcliente=2;
	update tabla_clientes tc set tc.direc.calle='calle Estopa,34' where idcliente =2;

-- 6.7 Consulta todos los datos del cliente 1 y añade un nuevo teléfono a su lista de teléfonos. Haz la consulta de otra forma usando value
	select * from tabla_clientes cli where idcliente=1;
	
	select value(cli) from tabla_clientes cli where idcliente=1;
	
-- 6.8 Visualiza el nombre del cliente que ha realizado la venta
	select tv.idcliente.nombre from tabla_ventas tv;
	
-- 6.8.2 Haz la misma consulta usando DEREF
	select deref(idcliente).nombre from tabla_ventas;
	

-- 6.9 Visualiza todos los datos del cliente anterior, que ha realizado la venta 2
	select deref(idcliente) from tabla_ventas where idventa=2;

-- 6.10 Visualizar el numero de venta y el total de ventas hechas por el cliente 1
	select idventa, tv.total_venta() from tabla_ventas tv where tv.idcliente.idcliente =1;
	
	select idventa, tv.total_venta() from tabla_ventas tv where deref(idcliente).idcliente =1;

-- 6.11 Visualiza las ventas de todos los clientes
	select idventa,deref(idcliente).idcliente cliente, lin.idproducto.descripcion producto, lin.cantidad from tabla_ventas tv, table(tv.lineas) lin;

-- 6.12 Crea un procedimiento que reciba como parámetro un id de venta y visualice los datos de la venta cuyo identificador recibe
