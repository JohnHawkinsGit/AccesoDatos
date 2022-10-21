-- Crea un tipo para almacenar direcciones postales con dos campos llamado Tipo_direccion
create or replace type tipo_address as object(
  dir varchar(100), cp number(5));
/

-- Crea un tipo contacto (tipo_contacto)para almacenar un número de teléfono y un email.
create or replace type tipo_contacto as object(
   telefono number, email varchar(100));
/  


--Crea un tipo persona (tipo_persona) con los campos id, nombre, apellido, dirección y contacto. 
create or replace type tipo_person as object(
   id varchar(20),
   nombre varchar(30),
   apellido varhcar(30),
   direccion tipo_address,
   contacto tipo_contacto)
   not final
/

--Después crea un subtipo cliente (tipo_cliente)con otro campo adicional llamado número de pedidos.
create or replace type tipo_customer under tipo_person(
   n_pedidos number)
/ 


-- Describe el tipo_direccion, el tipo_contacto , el tipo persona y el tipo cliente
desc tipo_address;
desc tipo_contacto;
desc tipo_person;
desc tipo_customer;  

-- Crea un tipo artículo (tipo_articulo)con los campos id, nombre, descripción, precio y porcentaje de iva.
create or replace type tipo_articulo as object(
   idart number,
   nombre varchar(30),
   descripcion varchar(100),
   precio number,
   porct_iva number)
/
 
--Después crea un tipo tabla anidada (tabla_articulos) as table of tipo_articulo.
create type tabla_articulos as table of tipo_articulo;
/

-- Describe el tipo articulo.
desc tipo_articulo;

-- Crea un tipo para la lista de la compra(tipo_lista_compra) y otro para su detalle (tipo_lista_detalle).
-- El tipo_lista_detalle contendrá un numero number, artículo de tipo_articulo y la cantidad number.
create or replace type tipo_lista_detalle as object(
   numero number,
   articulo tipo_articulo,
   cantidad number)
/

-- El tipo_lista_compra contendrá un identificador, fecha, cliente (será una referencia al tipo_cliente) 
-- y un atributo llamado detalle que será una tabla anidada de tipo_lista_detalle. 
-- Se deberá incluir en la definición una función miembro para calcular el total de la lista de la compra.
create type tipo_lista_compra as object(
   id number,
   fecha date,
   cli REF tipo_customer,
   detalle tab_lista_detalle,
   member function total return number)
/  

-- (crea previamente el tipo tabla anidada llámalo tab_lista_detalle as table of tipo_lista_detalle).
create type tab_lista_detalle as table of tipo_lista_detalle;
/


-- Crea el body del tipo lista de la compra para definir el método total.
create type body tipo_lista_compra as
   member function total return number is
      i integer;
      tot number:=0;

begin
   for i in 1..Detalle.count loop
      tot:=tot+(Detalle(i).cantidad* Detalle(i).articulo.precio)*
      (1+(Detalle(i).articulo.porct_iva/100));
   end loop;
   return tot;
   end;
end;
/      


-- Crea una tabla clientes e inserta dos clientes con número pedidos a 0.
create table customers of tipo_customer;

insert into customers values(1,'Pedro','Suarez',tipo_address('Paseo del museo, 15', '28009'),
												tipo_contacto(938383838,'psuarez@ono.es'),0);

´insert into customers values(2,'Juana','Gomez',tipo_address('Gran Vía, 15', 28005),
                                                tipo_contacto(988888888,'jgomez@ono.es'),0);

-- Crea la tabla para las listas de la compra e inserta una lista de la compra con un detalle de dos artículos para el cliente id =1
create table listas_de_compras of tipo_lista_compra nested table Detalle store as tDetalle;

insert into listas_de_compras select 1, current_date, ref(c), tab_lista_detalle(
									tipo_lista_detalle(1,tipo_articulo(1,'Barra de pan','baguette',1,7),4),  
									tipo_lista_detalle(2,tipo_articulo(2,'lonchas de jamón','ibérico',6,7),4)) 
									from customers c where c.id=1;
									
insert into listas_de_compras values(3, sysdate,(select ref(c)
							from customers c 
		     				        where c.id=1), tab_lista_detalle(tipo_lista_detalle(1,tipo_articulo(1,'Barra de pan','baguette',1,7),4),  
								                         tipo_lista_detalle(2,tipo_articulo(2,'lonchas de jamón','ibérico',6,7),4)));									

-- Muestra con una select los datos de la lista de la compra.
select * from listas_de_compras; 
select id,fecha, deref(cli), detalle from listas_de_compras;

-- Construye una select para mostrar por pantalla el id de una lista de la compra y su total.
select id, c.total() from listas_de_compras c;

