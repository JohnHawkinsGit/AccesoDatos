--Crear un tipo colección llamado colec_tipo_nombres_dept que tendrá como máximo grupos
--de 7 valores y además serán de máximo 30 caracteres.
create type tipo_nombres_dep is varray(7) of varchar(30);
/

--Crea la tabla departementos con (Region varchar(25), Nombres_dept de tipo coleccion)
create table departamentos(
	region varchar(25),
	nombres_dept tipo_nombres_dep);

--Insertar los datos que aparecen en la tabla anterior.
insert into departamentos values('Europa',tipo_nombres_dep('shipping','sales','finances'));
insert into departamentos values('America',tipo_nombres_dep('sales','finances','shipping'));
insert into departamentos values('Asia',tipo_nombres_dep('finances','payroll','shipping','sales'));
--Visualizar todos los departamentos.
select * from departamentos;

--Bloques PL

--Crea un bloque PL en el que declararemos una variable de tipo colección 
--y le asignaremos los siguientes valores a la colección (benefits,advertising,contracting,executive,marketing)
-- Actualizará los departamentos de la región de europa con los inicializados anteriormente.
--Recorrera la colección para visualizar todos los nombres de los departamentos de la región de Europa.
set serveroutput on;

declare 
  v_nombres  tipo_nombres_dep:=tipo_nombres_dep('benefits','advertising','contracting','executive','marketing');
  v_nombres2 tipo_nombres_dep;
  
begin
  update departamentos set nombres_dept=v_nombres where region='Europa';
  commit;

  select nombres_dept into v_nombres2 from departamentos where region='Europa';
  for i in v_nombres2.first..v_nombres2.last loop
     dbms_output.put_line('departamentos= '|| v_nombres2(i));
  end loop;
end;
/   


--Crear otro bloque PL para visualizar la región y sus departamentos para todas las regiones (necesitarás un cursor)

declare 
  cursor c_depts is select * from departamentos;
  v_region varchar(25);
  v_nombres tipo_nombres_dep;

begin
  open c_depts;
  loop
    fetch c_depts into v_region, v_nombres;
    exit when c_depts%NOTFOUND;
    dbms_output.put_line('Region: '||v_region);
       for i in v_nombres.first..v_nombres.last loop
	  dbms_output.put_line('departamento'||'('||i||')'||v_nombres(i));
       end loop;
   end loop;
end;
/      
  
--con 2 buscles forç
declare
  cursor v_zonas is select * from departamentos;
  
begin
  for i in v_zonas loop
    dbms_output.put_line('Region: '||i.region);
    for j in i.nombres_dept.first..i.nombres_dept.last loop
       dbms_output.put_line('departamento'||'('||j||')'||i.nombres_dept(j));
    end loop;   
  end loop;  
end;
/    