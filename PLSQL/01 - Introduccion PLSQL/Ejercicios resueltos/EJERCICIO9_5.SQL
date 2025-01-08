SET SERVEROUTPUT ON
 -- Solicitar al usuario que ingrese el nombre del tablespace
    ACCEPT TABLESPACE_NAME CHAR PROMPT 'Ingrese el nombre del tablespace: ';
DECLARE
    v_tablespace_name VARCHAR2(30);
    v_datafile_name VARCHAR2(100);
BEGIN

    -- Asignar el valor ingresado por el usuario a la variable
    v_tablespace_name := UPPER('&TABLESPACE_NAME');

    -- Consulta para obtener el nombre del primer datafile del tablespace
    SELECT FILE_NAME
    INTO v_datafile_name
    FROM DBA_DATA_FILES
    WHERE TABLESPACE_NAME = v_tablespace_name
    AND ROWNUM = 1; -- Obtener solo el primer registro

    -- Imprimir el nombre del datafile sin la ruta
      DBMS_OUTPUT.PUT_LINE('Nombre del Datafile: ' || SUBSTR(v_datafile_name, INSTR(v_datafile_name, '\', -1) + 1));


EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datafiles para el tablespace ingresado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;
/
