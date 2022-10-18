--Se crea el tipo direccion
create or replace type direccion as object
(calle varchar(25), ciudad varchar(20),codigo_post number(5));
/

-- se crea la tabla que va a ser anidada
create type tabla_anidada as table of direccion;
/

-- se crea la tabla con otra tabla anidada
create table ejemplo_tabla_anidada(
  id number(2), apellidos varchar2(35),
  direc tabla_anidada) nested table direc store as Direc_anidada;

-- Se usa desc para ver la composicion de las tablas
desc tabla_anidada;
desc ejemplo_tabla_anidada;

--Se insertan registrors en la tabla
insert into ejemplo_tabla_anidada values(1,'RAMOS', tabla_anidada(
		direccion('calle Manantiales,2','Guadalajara',19984),
		direccion('calle Manantiales,14','Guadalajara',19984),
		direccion('calle Paris,78','Caceres',10005),
		direccion('calle Segovia,89','Toledo',45555)));
		
insert into ejemplo_tabla_anidada values(2,'MARTIN', tabla_anidada(
		direccion('calle Huesca,2','Alcala de H',28808),
		direccion('calle Madrid,14','Alcorcon',28999)));

--Se muestra la informacion de la tabla
select *from ejemplo_tabla_anidada;

--Se muestra la informacion de la tabla anidada para el id 1
select e.direc from ejemplo_tabla_anidada e where e.id=1;
 
--se muestra la informacion de la tabla anidada para el id 1 de forma organizada 
select dir.calle from ejemplo_tabla_anidada e, table(e.direc) dir where e.id=1; 

--Se actualiza la direccion
update table(select direc from ejemplo_tabla_anidada where id=1) primera 
      set value(primera)=direccion('Calle Pinzon,13','Toledo',45555) 
	  where value(primera)= direccion('calle Manantiales,2','Guadalajara',19984);		

--Se inserta una nueva direccion	  
insert into table(select e.direc from ejemplo_tabla_anidada e where id=1)
  values(direccion('Calle Los Naranjos,99','Murcia',78788));

--Se muestra la tabla anidada para mostrar los cambios  
select dir.* from ejemplo_tabla_anidada e, table(e.direc) dir where e.id=1; 

--Se actuliza la direccion para el id 1
update ejemplo_tabla_anidada set direc= tabla_anidada(direccion('calle Sol,2','Madrid',19984), 
													  direccion('calle Luna,2','Murcia',19984),
													  direccion('calle Cielo,2','Burgos',19984)) 
													  where id=1;
													  
--Se borran las direcciones
delete from table(select e.direc from ejemplo_tabla_anidada e where id=1) primera where value(primera)=direccion('calle Cielo,2','Burgos',19984);