/*
A partir del tipo_cubo creado en la práctica 2, añadir un nuevo
método (procedimiento) de tipo static llamado nuevoCubo con
los atributos
V_largo INTEGER
V_ancho INTEGER
V_alto INTEGER
*/
SET SERVEROUTPUT ON;
ALTER TYPE TIPO_CUBO REPLACE AS OBJECT(
LARGO INTEGER,
ANCHO INTEGER,
ALTO INTEGER,
MEMBER FUNCTION SUPERFICIE RETURN INTEGER,
MEMBER FUNCTION VOLUMEN RETURN INTEGER,
MEMBER PROCEDURE MOSTRAR,
STATIC PROCEDURE NUEVO_CUBO(V_LARGO INTEGER,V_ANCHO INTEGER, V_ALTO INTEGER));
/

--Desarrollar el procedimiento en el body de tal forma que
--realice el insert en la tabla cubos del nuevoCubo.
CREATE OR REPLACE TYPE BODY TIPO_CUBO AS
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
    
    STATIC PROCEDURE NUEVO_CUBO(V_LARGO INTEGER,V_ANCHO INTEGER, V_ALTO INTEGER)
    IS
    BEGIN
      INSERT INTO CUBOS VALUES(V_LARGO,V_ANCHO,V_ALTO);
    END;  
    
END;
/

--Crear un pequeño bloque que llame al método nuevoCubo pasándole 
--como parámetros estos valores (1,8,1).

BEGIN
  TIPO_CUBO.NUEVO_CUBO(1,8,1);
END;
/  
SELECT * FROM CUBOS