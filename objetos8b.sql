--usando el ejemplo de la práctica 6  redefine el tipo hijos 
--con un tipo tabla llamado tabla_hijos de tipo varchar(30).

create type tabla_hijos as table of varchar(30);
/

--Crea la tabla empleado basándola en el tipo tabla_hijos
create table staff2( id number, nombre varchar(30), 
		apellidos varchar(30),
		hijos tabla_hijos) nested table hijos store as t_hijos
/

--Consulta los objetos de la base de datos
select object_name, object_type, status from all_objects where object_name like '%HIJO%';

--Consulta las estructuras de almacenamiento que usa oracle para almacenar los objetos (hay ser dba).
select segment_name, segment_type from user_segments where segment_name like '%HIJO%';

--Inserta dos empleados con estos datos
insert into staff2 values(1,'Fernando','Moreno', tabla_hijos('Elena','Pablo'));
insert into staff2 values(2,'David','Sanchez', tabla_hijos('Carmen','Candela'));

--Lista todos los empleados
select * from staff2;

--Lista todos los hijos del empleado 1, usando TABLE
select st.* from staff2 s, table(s.hijos) st where s.id=1;

--Actualiza la tabla empleado cambiando el nombre de los hijos del empleado idemp 1 por Carmen, Candela, Cayetana.
update staff2 set hijos=tabla_hijos('Carmen','Candela','Cayetana') where id=1;

--Listar todos los hijos del empleado 1 y 2
select st.* from staff2 s, table(s.hijos) st;
select st.* from staff2 s, table(s.hijos) st where s.id=1 or s.id=2;
;