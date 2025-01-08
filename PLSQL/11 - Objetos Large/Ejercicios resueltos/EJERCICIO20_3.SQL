CREATE TABLE DOCUMENTOS (
  ID_DOC NUMBER(4),
  NOMBRE_DOC VARCHAR2(80),
  DOCUM BFILE
 );
 
 INSERT INTO DOCUMENTOS (ID_DOC, NOMBRE_DOC) VALUES (
    1, 
    'Funciones del Administrador de BD'
);

INSERT INTO DOCUMENTOS (ID_DOC, NOMBRE_DOC) VALUES (
    2, 
    'Características de los objetos LOB – ORACLE 9i'
);

INSERT INTO DOCUMENTOS (ID_DOC, NOMBRE_DOC) VALUES (
    3, 
    'Objetos en las BD ORACLE'
);

INSERT INTO DOCUMENTOS (ID_DOC, NOMBRE_DOC) VALUES (
    4, 
    'Uso de paquetes estandar'
);
--ACTUALIZAR UN BFILE
CREATE OR REPLACE PROCEDURE CARGAR_DOCUM IS
    NOMBRE_ARCHIVO VARCHAR2(100);
    CURSOR C_DOCUMENTOS IS 
        SELECT *
        FROM DOCUMENTOS
        FOR UPDATE;
    ARCHIVO BFILE;
BEGIN
    FOR REG IN C_DOCUMENTOS LOOP
        BEGIN
            NOMBRE_ARCHIVO := 'docum' || TO_CHAR(REG.ID_DOC) || '.pdf';
            ARCHIVO := BFILENAME('MIS_DOCUMENTOS', NOMBRE_ARCHIVO);
            IF DBMS_LOB.FILEEXISTS(ARCHIVO) = 1 THEN 
                DBMS_LOB.FILEOPEN(ARCHIVO);
                
                UPDATE DOCUMENTOS D 
                SET D.DOCUM = ARCHIVO
                WHERE CURRENT OF C_DOCUMENTOS;
                
                DBMS_LOB.FILECLOSE(ARCHIVO);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error procesando documento con ID: ' || REG.ID_DOC || ' - ' || SQLERRM);
        END;
    END LOOP;
END;
/
