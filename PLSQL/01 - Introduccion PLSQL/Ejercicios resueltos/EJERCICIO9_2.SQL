CREATE TABLE SECUENCIADOR(
	NUMERO NUMBER,
	VALOR_PAR VARCHAR2(30) NULL,
	VALOR_IMPAR VARCHAR2(30) NULL
)

DECLARE
	v_contador number(3) := 1;
BEGIN
	LOOP 
		if v_contador MOD 2 = 0 THEN
			INSERT INTO SECUENCIADOR (NUMERO, VALOR_PAR) 
			VALUES (v_contador, 'es par: '|| v_contador);
			DBMS_OUTPUT.PUT_LINE('Valor par: '|| v_contador);
		ELSE
			INSERT INTO SECUENCIADOR (NUMERO, VALOR_IMPAR) 
			VALUES (v_contador, 'es impar: '|| v_contador);
			DBMS_OUTPUT.PUT_LINE('Valor impar: '|| v_contador);
		END IF;
		v_contador := v_contador + 1;
		EXIT WHEN (v_contador > 100);
	END LOOP;
END;
/
