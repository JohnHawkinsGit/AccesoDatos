-- Crear un tipo objeto llamado telefono con dos atributos
create or replace type telefono as object (tipo varchar(30), numero number);
/

-- Crear una tabla tipo llamada listin basada en el tipo objeto, para añadir la funcionalidad de múltiples valores.
create type listin as table of telefono;
/

-- Crear la tabla clientes
create table clientes(
	id_cli varchar(30),
	nombre varchar(30),
	apellido varchar(30),
	direccion varchar(30),
	poblacion varchar(30),
	provincia varchar(30),
	telefonos listin)nested table telefonos store as tel_tab
/
--Inserta 3 registros, con 3 teléfonos cada uno.
insert into clientes values(1,'Jorge','Maria','Calle Marroquina','Madrid','Madrid',
							listin(telefono('Movil',679685461),
							telefono('casa',915854715),
							telefono('trabajo',620458878)));
							
insert into clientes values(2,'Carlos','Teso','Calle Miguel Hernandez','Madrid','Madrid',
							listin(telefono('Movil',686514722),
							telefono('casa',666555111),
							telefono('Fax',987456321)));

insert into clientes values(3,'Jose','Blanco','Calle Lesseps','Barcelona','Barcelona',
							listin(telefono('Movil',665588779),
							telefono('casa',522254547),
							telefono('trabajo',667788552)));							

-- Selecciona todos los clientes
select * from clientes;

-- Consulta las estructuras de almacenamiento que usa oracle para almacenar los objetos
select segment_name, segment_type from user_segments where segment_name like '%TEL_TAB%';	

-- Consulta los objetos de la base de datos
select object_name, object_type, status from all_objects where object_name like '%TEL_TAB%';

-- Lista la vista user_nested_tables


-- Lista todos los teléfonos del cliente 3, usando el operador TABLE.
select tl.* from clientes c, table(c.telefonos) tl where c.id_cli=3;

-- Actualiza la tabla clientes cambiando los números de teléfono del cliente 1 por :
update clientes set telefonos=listin(telefono('fijo',934444444),
									 telefono('movil personal',65555555),
									 telefono('movilempresa',644444444)) 
									     where id_cli=1;

-- Visualizar todos los teléfonos de todos los clientes
select tl.* from clientes c, table(c.telefonos) tl;

select tl.* from clientes c, table(c.telefonos) tl where c.id_cli=1 or c.id_cli=2 or c.id_cli=3;


-- Visualizar el nombre, id , tipo de teléfono, número de teléfono de
--todos los teléfonos de todos los clientes
select c.nombre, c.id_cli, tl.* 
       from clientes c, table(c.telefonos) tl;

select c.nombre, c.id_cli, tl.* 
       from clientes c, table(c.telefonos) tl 
	            where c.id_cli=1 or c.id_cli=2 or c.id_cli=3;