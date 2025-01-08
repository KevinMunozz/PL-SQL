SET SERVEROUTPUT ON
ACCEPT CEDULA_INGRESADA NUMBER PROMPT 'INGRESE NUMERO DE CEDULA: ';
DECLARE
    v_cedula b_empleados.cedula%TYPE := &&CEDULA_INGRESADA;
    v_nombre_apellido VARCHAR2(50);
    v_asignacion b_categorias_salariales.asignacion%TYPE;
    v_nombre_cat b_categorias_salariales.nombre_cat%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cédula ingresada: ' || v_cedula);
    SELECT  
        E.NOMBRE || ' ' || E.APELLIDO,
        CS.ASIGNACION,
        CS.NOMBRE_CAT
    INTO     
        v_nombre_apellido,
        v_asignacion,
        v_nombre_cat
    FROM B_EMPLEADOS E
    LEFT JOIN B_POSICION_ACTUAL PA ON E.CEDULA = PA.ID
    LEFT JOIN B_CATEGORIAS_SALARIALES CS ON PA.ID = CS.COD_CATEGORIA
    WHERE E.CEDULA = v_cedula;

    DBMS_OUTPUT.PUT_LINE('Datos del empleado');
    DBMS_OUTPUT.PUT_LINE('Nombre y apellido: ' || v_nombre_apellido);
    DBMS_OUTPUT.PUT_LINE('Nombre categoria salarial: ' || v_nombre_cat);
    DBMS_OUTPUT.PUT_LINE('Asignacion: ' || v_asignacion);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para la cédula ingresada.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;
/
