SET SERVEROUTPUT ON
ACCEPT VALOR_INGRESADO NUMBER PROMPT 'INTRODUCE UN NUMERO: ';

DECLARE
    v_auxiliar NUMBER := &&VALOR_INGRESADO;
BEGIN
    WHILE v_auxiliar > 1 LOOP
        v_auxiliar := v_auxiliar - 2;
    END LOOP;

    IF v_auxiliar = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El valor es par: ' || &&VALOR_INGRESADO);
    ELSE
        DBMS_OUTPUT.PUT_LINE('El valor es impar: ' || &&VALOR_INGRESADO);
    END IF;
END;
/
