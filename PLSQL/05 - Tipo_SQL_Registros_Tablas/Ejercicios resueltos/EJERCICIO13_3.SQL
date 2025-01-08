CREATE OR REPLACE PROCEDURE P_ESTRUCTURA (P_TABLA IN VARCHAR2 DEFAULT NULL) IS
	TYPE T_COL IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
	TYPE R_TABLA IS RECORD (
		NOMBRE_TABLA VARCHAR2(30),
		COLUMNAS T_COL
	);
	TYPE T_TAB IS TABLE OF R_TABLA INDEX BY BINARY_INTEGER;
	V_TAB T_TAB;
	V_INDEX BINARY_INTEGER := 1; -- Índice para la tabla de resultados
	BEGIN
		IF P_TABLA IS NULL THEN
        -- Si no se proporciona un nombre de tabla, recuperar todas las tablas en el esquema
        FOR R IN (
            SELECT TABLE_NAME, COLUMN_NAME
            FROM USER_TAB_COLUMNS
        ) LOOP
            V_TAB(V_INDEX).NOMBRE_TABLA := R.TABLE_NAME;
            V_TAB(V_INDEX).COLUMNAS(V_INDEX) := R.COLUMN_NAME;
            V_INDEX := V_INDEX + 1;
        END LOOP;
    ELSE
        -- Si se proporciona un nombre de tabla, recuperar solo esa tabla
        FOR R IN (
            SELECT TABLE_NAME, COLUMN_NAME
            FROM USER_TAB_COLUMNS
            WHERE UPPER(TABLE_NAME) = UPPER(P_TABLA)
        ) LOOP
            V_TAB(V_INDEX).NOMBRE_TABLA := R.TABLE_NAME;
            V_TAB(V_INDEX).COLUMNAS(V_INDEX) := R.COLUMN_NAME;
            V_INDEX := V_INDEX + 1;
        END LOOP;
    END IF;
		
		FOR I IN 1 .. V_TAB.COUNT LOOP
			DBMS_OUTPUT.PUT_LINE('TABLE NAME: ' || V_TAB(I).NOMBRE_TABLA || ' COLUMNA: ' || V_TAB(I).COLUMNAS(I));
		END LOOP;
			DBMS_OUTPUT.PUT_LINE('LONGITUD DEL VECTOR: '||V_TAB.COUNT);
	END;
	/
	--SHOW ERRORS PROCEDURE P_ESTRUCTURA; ---> PARA VER ERRORES
	BEGIN
    P_ESTRUCTURA('B_ARTICULOS'); -- Si deseas ver la estructura de una tabla específica
    -- O simplemente
    -- P_ESTRUCTURA; -- Si deseas ver la estructura de todas las tablas

	END;

