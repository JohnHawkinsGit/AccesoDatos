CREATE OR REPLACE type direccion as object
(calle varchar(25),
ciudad varchar(20),
cod_postal number(5));
/

create or replace type persona as object
(codigo number,
nombre varchar2(35),
direc direccion,
fecha_nac date);
/

DECLARE 
dir direccion:=direccion(null,null,null);
p persona:=persona(null,null,null,null);
BEGIN
dir.calle:='La Mina,3';
dir.ciudad:='GUADALAJARA';
dir.cod_postal:=19001;
p.codigo:=1;
p.nombre:='Juan';
p.direc:=dir;
p.fecha_nac:='10/11/1988';
insert into alumnos values(p);
end;
/
--Crear una tabla alumnos de tipo persona
CREATE TABLE ALUMNOS OF PERSONA(CODIGO PRIMARY KEY);
desc alumnos;
--Insertar dos alumnos
insert into alumnos values(1,'Juan Perez', direccion('c/ Los manantiales,3','GUADALAJARA',19001),'30/09/1988');
insert into alumnos values(2,'Julia Breña', direccion('c/ Los espartales,25','GUADALAJARA',19001),'06/01/1985');

--Seleccionar las filas cuya ciudad sea Guadalajara
select * from alumnos a where a.direc.ciudad='GUADALAJARA';

--Seleccionar código, Direc(columna de tipo objeto) de los alumnos
select codigo, a.direc from alumnos a;


--Modificar las filas cuya ciudad sea Guadalajara y convertir la ciudad a minúscula
update alumnos a set a.direc.ciudad=lower(a.direc.ciudad) where a.direc.ciudad='GUADALAJARA';


--Crear un bloque PL que muestre el nombre y la calle de los alumnos

DECLARE 
cursor c1 is select * from alumnos;
begin
   for i in c1 loop
      dbms_output.put_line(i.nombre||' CALLE: '||i.direc.calle);
   end loop;
end;
/

--Eliminar aquellas filas cuya ciudad sea Guadalajara

delete alumnos a where a.direc.ciudad='guadalajara';