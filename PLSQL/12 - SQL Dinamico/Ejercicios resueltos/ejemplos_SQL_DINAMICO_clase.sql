
SET SERVEROUTPUT  ON
/* Ejemplos de SQL Dinámico Nativo */
DECLARE
    str_sql VARCHAR2(255);
BEGIN
     
	  str_sql:= 'DROP TABLE tmp_dept ';  
     EXECUTE IMMEDIATE  str_sql;
	 
	 str_sql:= 'CREATE TABLE tmp_dept 
      (id NUMBER, nombre VARCHAR2(30))';  
     EXECUTE IMMEDIATE  str_sql;
	 
END; 
	  
SET SERVEROUTPUT  ON
 DECLARE
       str_sql VARCHAR2(255);
       l_cnt   VARCHAR2(20);
	   v_id    NUMBER(8) := 646237;
	   v_nombre VARCHAR2(40); 
	   v_precio NUMBER(9);
	   
BEGIN
     
     str_sql := 'SELECT count(*) AS CNT FROM B_ARTICULOS';
     EXECUTE IMMEDIATE str_sql INTO l_cnt;
     dbms_output.put_line('Cantidad reg.= ' || To_char( l_cnt));
	 
	  str_sql := 'SELECT NOMBRE , PRECIO FROM B_ARTICULOS
				 WHERE ID = 646237 ' ;
     EXECUTE IMMEDIATE str_sql INTO v_nombre, v_precio;
     dbms_output.put_line('Articulo = '|| v_nombre  || 'Precio '|| To_char( v_precio));
	 
	   dbms_output.put_line('CON USO DE VARIABLE --  ');
	  str_sql := 'SELECT NOMBRE , PRECIO FROM B_ARTICULOS
				 WHERE ID = :v_id ' ;
     EXECUTE IMMEDIATE str_sql INTO v_nombre, v_precio USING v_id;
     dbms_output.put_line('Articulo = '|| v_nombre  || 'Precio '|| To_char( v_precio));
	 
END; 

--2
DECLARE
   str_sql   VARCHAR2(255);
    
   type t_emp is record
   (id number,
    nombre varchar2(30));
	
   emp_rec t_emp;
   
   P_id number(5);
   P_nombre varchar2(30);
   
   v_id number := 10;
BEGIN
     
   str_sql := 'INSERT INTO tmp_dept VALUES (:1, :2)';
   EXECUTE IMMEDIATE str_sql USING 10, 'Administración';
   
   commit ;
   
   str_sql := 'SELECT id , nombre FROM tmp_dept WHERE id = :v_id ' ;
   EXECUTE IMMEDIATE str_sql INTO P_id, P_nombre USING v_id;
   
    DBMS_OUTPUT.PUT_LINE( TO_CHAR(P_id)  ||'-'|| P_nombre);
		 
   str_sql := 'SELECT * FROM tmp_dept WHERE id = :v_id ' ;
   EXECUTE IMMEDIATE str_sql INTO emp_rec USING v_id;
     DBMS_OUTPUT.PUT_LINE( TO_CHAR(emp_rec.id) 
		 ||'-'|| emp_rec.nombre);
   
END;
/

--3

 SET SERVEROUTPUT  ON
DECLARE
   TYPE r_loc IS RECORD
   (id  NUMBER(8), nombre VARCHAR2(40)); 
   
   TYPE t_loc IS TABLE OF r_loc 
    INDEX BY BINARY_INTEGER;
	
   v_loc t_loc;  
   ind NUMBER;
BEGIN
   EXECUTE IMMEDIATE  'SELECT id, nombre FROM B_LOCALIDAD'
       BULK COLLECT INTO v_loc;
   ind := v_loc.FIRST;
   WHILE ind <= v_loc.LAST LOOP
         		 
	 DBMS_OUTPUT.PUT_LINE( TO_CHAR( v_loc(ind).id )
		 ||'-'|| v_loc(ind).nombre );
		 
         ind:= v_loc.NEXT(ind);
   END LOOP;   
END;
/
--BULK COLLECT
 SET SERVEROUTPUT  ON
   DECLARE   
   TYPE Articulos_TYPE IS TABLE OF B_ARTICULOS%ROWTYPE;    
   
    iArt Articulos_TYPE;   
   BEGIN   
      -- Carga los registros en la colección iArt con ayuda de BULK COLLECT
      SELECT *
      BULK COLLECT INTO iArt
      FROM B_ARTICULOS
      WHERE rownum < 10;
      
      -- Iteremos sobre la colección iArt para mostrar su contenido
      FOR i IN iArt.FIRST .. iArt.LAST LOOP     
         dbms_output.put_line(iArt(i).id || ', ' || iArt(i).nombre);     
		 
      END LOOP;
 END;
 /
 

 SET SERVEROUTPUT  ON				
 DECLARE
  ret NUMBER;
  
  FUNCTION fn_execute RETURN NUMBER IS
    sql_str VARCHAR2(1000);
  BEGIN
    sql_str := 'UPDATE B_ARTICULOS SET NOMBRE = ''SIN NOMBRE'' 
                WHERE ID = 0';    
    EXECUTE IMMEDIATE sql_str;   
    RETURN SQL%ROWCOUNT;
  END fn_execute ;
  
BEGIN
     ret := fn_execute();
     dbms_output.put_line(TO_CHAR(ret));
END; 


 -- uso de variable host con clausula USING
   SET SERVEROUTPUT  ON
  DECLARE
  ret NUMBER;
  FUNCTION fn_execute(nombre VARCHAR2, codigo NUMBER) RETURN NUMBER 
  IS
    sql_str VARCHAR2(1000);
  BEGIN
    sql_str := 'UPDATE B_ARTICULOS SET NOMBRE = :new_nombre 
                WHERE ID = :codigo';    
    
    EXECUTE IMMEDIATE sql_str USING nombre, codigo;   
    RETURN SQL%ROWCOUNT;
  END fn_execute ;
BEGIN
    
     ret := fn_execute('CUCHILLO profesional Tramontina',646237);
     dbms_output.put_line(TO_CHAR(ret));
END;
/


 -- Cursores con SQL dinámico
-- REF CURSOR 
 SET SERVEROUTPUT  ON
  DECLARE
  TYPE CUR_TYP IS REF CURSOR;
  
  c_cursor  CUR_TYP;
  fila      B_ARTICULOS%ROWTYPE;
  v_query   VARCHAR2(255);
  
BEGIN
  v_query := 'SELECT * FROM B_ARTICULOS';
 
  OPEN c_cursor FOR v_query;
  LOOP
    FETCH c_cursor INTO fila;
	
    EXIT WHEN c_cursor%NOTFOUND;
      dbms_output.put_line(fila.nombre);
  END LOOP;
  CLOSE c_cursor;
END; 
/

-- Las varibles host tambien se pueden utilizar en los cursores.
 SET SERVEROUTPUT  ON
 DECLARE
  TYPE cur_typ IS REF CURSOR;
  
  c_cursor    CUR_TYP;
  fila        B_ARTICULOS%ROWTYPE;
  v_query     VARCHAR2(255);
  id_articulo NUMBER (8) := 646237;
BEGIN

  v_query := 'SELECT * FROM B_ARTICULOS WHERE id = :pID';
   
 OPEN c_cursor FOR v_query USING id_articulo;
 
  LOOP
    FETCH c_cursor INTO fila;
    EXIT WHEN c_cursor%NOTFOUND;
    dbms_output.put_line(fila.nombre);
  END LOOP;
  CLOSE c_cursor;
END;
/
 
   SET SERVEROUTPUT  ON
 DECLARE   
    TYPE Articulos_TYPE IS TABLE OF B_ARTICULOS%ROWTYPE;    
   
    iArt Articulos_TYPE;  
    v_sql varchar2(256);
	
   BEGIN   
      v_sql := ' SELECT * FROM B_ARTICULOS WHERE rownum < 10';
      -- BULK COLLECT con SQL DINAMICO
      execute immediate v_sql BULK COLLECT INTO iArt;
        
       -- Iteremos sobre la colección iArt para mostrar su contenido
      FOR i IN iArt.FIRST .. iArt.LAST LOOP     
         dbms_output.put_line(iArt(i).id || ', ' || iArt(i).nombre);         
      END LOOP;
 END;

 --********************************
 -- USO DEL PAQUETE DBMS_SQL
   SET SERVEROUTPUT  ON
 DECLARE
   
	v_sql VARCHAR2(500);
	v_id_cursor integer;
	v_cnt_filas integer;
	
BEGIN
      v_sql :='drop table tmpEmpleado ';
	  
     v_id_cursor :=dbms_sql.open_cursor;
	dbms_sql.parse (v_id_cursor ,v_sql, dbms_sql.native);
 
	--v_cnt_filas := dbms_sql.execute(v_id_cursor);
	--dbms_sql.close_cursor(v_id_cursor);
END;

  -- Ejecución de tipo de sentencia  (Creación de tabla)
 SET SERVEROUTPUT  ON
 DECLARE
   
	v_sql VARCHAR2(500);
	v_id_cursor integer;
	v_cnt_filas integer;
	
BEGIN
      v_sql :='Create table tmpEmpleado (id_empleado number,salario number)';
	  
     v_id_cursor :=dbms_sql.open_cursor;
	dbms_sql.parse (v_id_cursor ,v_sql, dbms_sql.native);
 
	--v_cnt_filas := dbms_sql.execute(v_id_cursor);
	--dbms_sql.close_cursor(v_id_cursor);
END;



--**************************
  --Ejemplo: Ejecución de tipo de sentencia  (Orden DML No select)
SET SERVEROUTPUT  ON
  DECLARE
 
	v_sql VARCHAR2(500);
	v_id_cursor integer;
	v_cnt_filas integer;
	vid_empleado number(5);
	v_salario number(10);
BEGIN
		vid_empleado := 1;
		v_salario:= 1000000;
	
		v_sql:= 'insert into tmpEmpleado (id_empleado ,salario )
          values ( :vid_empleado, :v_salario )' ;
		  
	    v_id_cursor :=DBMS_SQL.open_cursor;
	    DBMS_SQL.PARSE (v_id_cursor ,v_sql, dbms_sql.native);
	
	 		
		DBMS_SQL.BIND_VARIABLE(v_id_cursor,':vid_empleado', vid_empleado);
		DBMS_SQL.BIND_VARIABLE(v_id_cursor,':v_salario', v_salario);
		
		v_cnt_filas := DBMS_SQL.execute(v_id_cursor);
		-- Obtenemos el número de filas afectadas
		Dbms_output.put_line(v_cnt_filas);
		
		DBMS_SQL.close_cursor(v_id_cursor);
END;

--***************************
   --**Ejemplo: Ejecución de tipo de sentencia  (Orden SQL)
 SET SERVEROUTPUT  ON
	DECLARE
	v_sql VARCHAR2(500);
	v_nro_cedula NUMBER(11);
	v_nombre VARCHAR2(30);
	v_apellido VARCHAR2(30);
	v_telefono VARCHAR2(15);
	v_id_cursor integer;
	v_cnt_filas integer;
	
	BEGIN
	    v_nro_cedula:= 1 ;
		v_sql:= 'SELECT NOMBRE ,APELLIDO , TELEFONO
				FROM B_EMPLEADOS WHERE CEDULA >= :nro_cedula';
 
		v_id_cursor := DBMS_SQL.OPEN_CURSOR;
        
		DBMS_SQL.PARSE(v_id_cursor, v_sql, DBMS_SQL.NATIVE);
		 
		DBMS_SQL.BIND_VARIABLE(v_id_cursor, ':nro_cedula' , v_nro_cedula);

		DBMS_SQL.DEFINE_COLUMN(v_id_cursor,1,v_nombre , 30);
		DBMS_SQL.DEFINE_COLUMN(v_id_cursor,2,v_apellido, 30);
		DBMS_SQL.DEFINE_COLUMN(v_id_cursor,3,v_telefono , 15 );

		v_cnt_filas:= DBMS_SQL.EXECUTE(v_id_cursor);
	LOOP
		IF DBMS_SQL.FETCH_ROWS(v_id_cursor) = 0 THEN
			EXIT;
		ELSE
			
			DBMS_SQL.COLUMN_VALUE(v_id_cursor,1, v_nombre);
			DBMS_SQL.COLUMN_VALUE(v_id_cursor,2, v_apellido);
			DBMS_SQL.COLUMN_VALUE(v_id_cursor,3, v_telefono);
			
			Dbms_output.put_line('CEDULA: '||  TO_CHAR(v_nro_cedula) ); 
			Dbms_output.put_line('NOMBRE: '|| v_nombre); 
			Dbms_output.put_line('APELLIDO:'|| v_apellido); 
			Dbms_output.put_line('TELEFONO :'|| v_telefono);
		END IF;
	END LOOP;

	 DBMS_SQL.CLOSE_CURSOR(v_id_cursor);
END;
/

  --- 
      SET SERVEROUTPUT  ON
  DECLARE
	v_cursor integer;
	v_tname char(30);
	v_status char(8);
	v_num_row number;
	v_rows integer;
	v_usuario varchar2(10);
	
	BEGIN
	   --abrir el cursor
	   v_usuario := 'BD2';
		v_cursor := DBMS_SQL.OPEN_CURSOR;
		--asociamos el query ( select ) al cursor
	    DBMS_SQL.PARSE(v_cursor, 'select table_name , status , 
					num_rows from all_tables 
					where owner = :x_owner' , DBMS_SQL.NATIVE );
	      --se asigna valor a la variable, en este ejemplo usamos BD2
	    DBMS_SQL.BIND_VARIABLE(v_cursor, ':x_owner', v_usuario);
				 
	      --definir la columna del cursor
	    DBMS_SQL.DEFINE_COLUMN_CHAR(v_cursor, 1, v_tname, 30);
		DBMS_SQL.DEFINE_COLUMN_CHAR(v_cursor, 2, v_status, 8);
		DBMS_SQL.DEFINE_COLUMN_CHAR(v_cursor, 3, v_num_row, 8);
		
		 --ejecutar el cursor
	    v_rows := DBMS_SQL.EXECUTE(v_cursor);
			LOOP 
				if DBMS_SQL.FETCH_ROWS(v_cursor) = 0 then
				--salir cuando no retorne filas
					exit;
				end if;
				--obtener el valor de la columna
				DBMS_SQL.COLUMN_VALUE_CHAR(v_cursor, 1, v_tname);
				DBMS_SQL.COLUMN_VALUE_CHAR(v_cursor, 2, v_status);
				DBMS_SQL.COLUMN_VALUE_CHAR(v_cursor, 3, v_num_row);
				--imprimimos el resultado
				DBMS_OUTPUT.PUT_LINE('Nombre de Tabla:'  || v_tname || ' status : ' || v_status  || ' cfilas :' || to_char(v_num_row) );
			end loop;
		--cerrar el cursor
			DBMS_SQL.CLOSE_CURSOR(v_cursor);
		EXCEPTION
			when others then
				--cerrar el cursor
				DBMS_SQL.CLOSE_CURSOR(v_cursor);
				raise_application_error(-20000, 'Excepcion:'  || TO_CHAR(sqlcode ) ||' ' ||  sqlerrm);
	END;
/

   ---str_sql:= 'CREATE TABLE tmp_dept 
    --  (id NUMBER, nombre VARCHAR2(30))';
	  
CREATE PROCEDURE insert_row(
		p_nombre_tabla  VARCHAR2,
		p_id VARCHAR2,
		p_nombre VARCHAR2 
		  )
		IS
		v_cursor INTEGER ;
		v_sql VARCHAR2(200);
		v_cant_filas INTEGER ;
BEGIN
		v_sql := 'INSERT INTO ' ||table_name||
				' VALUES (:cid, :cnombre)' ;
				
		v_cursor := DBMS_SQL.OPEN_CURSOR;
		
		DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);
		
		DBMS_SQL.BIND_VARIABLE(v_cursor,':cid', id);
		DBMS_SQL.BIND_VARIABLE(v_cursor,':cnombre', nombre);
		 
		v_cant_filas := DBMS_SQL.EXECUTE(v_cursor);
		DBMS_SQL.CLOSE_CURSOR(v_cursor);
		DBMS_OUTPUT.PUT_LINE( to_char(v_cant_filas)||' filas afectadas');
END;
/

  --***************************
  CREATE OR REPLACE PROCEDURE upd_tabla_articulos
       ( p_ncampo IN VARCHAR2,
         p_id IN NUMBER,
         p_valor  IN NUMBER )
		 IS
     v_cursor  INTEGER;
     -- Sentencia a ejecutar
     v_sql VARCHAR2(500);
    -- Número de rows actualizadas
     c_cnt_filas  INTEGER;
 BEGIN
      
		v_sql := 'UPDATE B_ARTICULOS SET ' || p_ncampo || ' = ' || p_valor ||
		         ' WHERE ID = ' || p_id;
		v_cursor := dbms_sql.open_cursor;
		 
		dbms_sql.parse (v_cursor, v_sql, dbms_sql.native);
		c_cnt_filas := dbms_sql.execute (v_cursor);
		dbms_sql.close_cursor (v_cursor);
 END;

	--Por lo tanto si ejecutamos el comando:

    EXEC upd_tabla_articulos ('PRECIO', 646237, 250000);

    EXEC upd_tabla_articulos ('COSTO', 646237, 200000);

	SELECT ID, NOMBRE , PRECIO , COSTO FROM B_ARTICULOS 
	WHERE ID= 646237 ;
	
	 --**************EJEJCUATAR
	 
 CREATE OR REPLACE PROCEDURE P_VER_TABLAS (P_ID NUMBER, P_TABLA VARCHAR2)  IS
  V_CURSOR NUMBER;
  V_SENTENCIA VARCHAR2(1000);
  V_FILAS  INTEGER;
  V_NOMBRE VARCHAR2(40);
  BEGIN
    V_CURSOR := DBMS_SQL.OPEN_CURSOR;
    IF  P_TABLA = 'B_AREAS' THEN
        V_SENTENCIA := 'SELECT NOMBRE_AREA FROM B_AREAS WHERE ID >= :PID';
    ELSIF P_TABLA = 'B_LOCALIDAD' THEN
        V_SENTENCIA := 'SELECT NOMBRE FROM B_LOCALIDAD WHERE ID = :PID';
    END IF;
    DBMS_SQL.PARSE(V_CURSOR, V_SENTENCIA, DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(V_CURSOR, ':PID' , P_ID);
    DBMS_SQL.DEFINE_COLUMN(V_CURSOR, 1, V_NOMBRE, 40);
    V_FILAS := DBMS_SQL.EXECUTE(V_CURSOR);
	LOOP
	  IF DBMS_SQL.FETCH_ROWS(V_CURSOR) = 0 THEN
			EXIT;
		ELSE
			DBMS_SQL.COLUMN_VALUE(V_CURSOR, 1, V_NOMBRE);
			DBMS_OUTPUT.PUT_LINE(V_NOMBRE);
       END IF;
	 END LOOP;
 
    DBMS_SQL.CLOSE_CURSOR(V_CURSOR);
 END;

 
SET SERVEROUTPUT  ON
 DECLARE
  P_ID NUMBER;
  P_TABLA VARCHAR2(200);
BEGIN
  P_ID := 1;
  P_TABLA := 'B_AREAS';

  P_VER_TABLAS( P_ID => P_ID, P_TABLA => P_TABLA );
 
END;

  -- cursor variable
  
SET SERVEROUTPUT  ON
 DECLARE
	TYPE tcursor IS REF CURSOR;
	v_cursor tcursor;
	v_rec dba_users%ROWTYPE;
	v_sql VARCHAR2(500);
	puser VARCHAR2(20);
BEGIN
     puser:= NULL ;
    v_sql:= 'SELECT * FROM dba_users ';
	
	IF puser IS NOT NULL THEN
		v_sql:= v_sql || ' WHERE USERNAME = ' || puser;
	END IF;
	OPEN v_cursor FOR v_sql;
	LOOP
		FETCH v_cursor INTO v_rec;
			EXIT WHEN v_cursor%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE(' user name '|| v_rec.USERNAME);
			DBMS_OUTPUT.PUT_LINE(' user id '  || to_char(v_rec.USER_ID));
			DBMS_OUTPUT.PUT_LINE(' Profile ' || v_rec.PROFILE);
	END LOOP;
	CLOSE v_cursor;
END;
/