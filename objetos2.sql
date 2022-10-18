CREATE TYPE TIPO_CUBO AS OBJECT(
LARGO INTEGER,
ANCHO INTEGER,
ALTO INTEGER,
MEMBER FUNCTION SUPERFICIE RETURN INTEGER,
MEMBER FUNCTION VOLUMEN RETURN INTEGER,
MEMBER PROCEDURE MOSTRAR);
/
--Crea el cuerpo de este tipo desarrollando las funciones y procedimientos
CREATE TYPE BODY TIPO_CUBO AS
   MEMBER FUNCTION SUPERFICIE RETURN INTEGER IS
   BEGIN
     RETURN 2*(LARGO*ANCHO+LARGO*ALTO+ANCHO*ALTO);
   END;

   MEMBER FUNCTION VOLUMEN RETURN INTEGER IS
   BEGIN
     RETURN LARGO*ANCHO*ALTO;
   END;


   MEMBER PROCEDURE MOSTRAR  IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('LARGO: '||LARGO||' ANCHO: '||ANCHO||' ALTO: '||ALTO);
      DBMS_OUTPUT.PUT_LINE('VOLUMEN: '||VOLUMEN||' SUPERFICIE: '||SUPERFICIE);
    END;
END;
/

-- Crea la tabla cubos de tipo cubo
CREATE TABLE CUBOS OF TIPO_CUBO;

--Inserta dos cubos con estas medidas( 10,10,10) y (3,4,5)
INSERT INTO CUBOS VALUES(TIPO_CUBO(10,10,10));
INSERT INTO CUBOS VALUES(TIPO_CUBO(3,4,5));
INSERT INTO CUBOS VALUES(3,4,7);--No es necesario indicar que es tipo_cubo

--Lista todos los cubos
SELECT * FROM CUBOS;

--Lista el volumen y la superficie del cubo de largo 10
SELECT C.VOLUMEN(),C.SUPERFICIE() FROM CUBOS C WHERE C.LARGO=10;

--Crea un pequeño bloque PL que visualice los datos largo, 
--ancho y alto del cubo de largo 10, 
--el bloque PL debe llamar al procedimiento mostrar()
DECLARE
  MI_CUBO TIPO_CUBO;
  BEGIN
    SELECT VALUE(C) INTO MI_CUBO FROM CUBOS C WHERE C.LARGO=10;
    MI_CUBO.MOSTRAR();
  END;
  /  