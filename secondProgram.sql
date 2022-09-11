CREATE OR REPLACE PROCEDURE programa2(codigo_socio IN SOCIO.IDSOCIO%TYPE) IS

  nombre_socio SOCIO.NOMBRE%TYPE;
  acumulado_socio SOCIO.S_ACUMULADO%TYPE;

  cantidad_cooperativas NUMBER(8);
  contador_impresor1 NUMBER(8) := 1;
  contador_impresor2 NUMBER(8) := 1;
  recorredor_arreglo NUMBER;

  cooperativas_ocupadas util.ARRAYSTRING;
  total_cooperativas util.ARRAYSTRING;

  CURSOR cooperativas_socio_programa2 IS
    SELECT *
    FROM COOPERATIVA INNER JOIN COOPEXSOCIO
    ON COOPERATIVA.CODIGO = COOPEXSOCIO.COOPE;

  CURSOR cooperativas_all IS
    SELECT CODIGO, NOMBRE
    FROM COOPERATIVA;

begin

  SELECT NOMBRE, S_ACUMULADO
  INTO nombre_socio, acumulado_socio
  FROM SOCIO
  WHERE IDSOCIO = codigo_socio;

  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('Nombre del socio: '||nombre_socio);

  if(acumulado_socio IS NULL) then
    DBMS_OUTPUT.PUT_LINE('Acumulado del socio: '||'0');
  else
    DBMS_OUTPUT.PUT_LINE('Acumulado del socio: '||acumulado_socio);
  end if;

  SELECT COUNT(*)
  INTO cantidad_cooperativas
  FROM COOPEXSOCIO
  WHERE SOCIO = codigo_socio;

  DBMS_OUTPUT.PUT_LINE('Numero de cooperativas en las que participa: '||cantidad_cooperativas);

  DBMS_OUTPUT.PUT_LINE('Cooperativas del socio:');
  DBMS_OUTPUT.PUT_LINE('{');

  for recorredor in cooperativas_socio_programa2 loop

    if(recorredor.SOCIO = codigo_socio) then
      if(recorredor.SC_ACUMULADO IS NULL) then
        recorredor.SC_ACUMULADO := 0;
      end if;

      DBMS_OUTPUT.PUT_LINE(contador_impresor1||'. '||'(Nombre: '||recorredor.NOMBRE||', Valorsc: '||recorredor.SC_ACUMULADO||')');
      cooperativas_ocupadas(recorredor.COOPE) := recorredor.NOMBRE;
      contador_impresor1 := contador_impresor1 + 1;
    end if;
  end loop;

  DBMS_OUTPUT.PUT_LINE('}');
  DBMS_OUTPUT.PUT_LINE('Cooperativas en las que no esta el socio:');
  DBMS_OUTPUT.PUT_LINE('{');

  for recorredor1 in cooperativas_all loop
    total_cooperativas(recorredor1.CODIGO) := recorredor1.NOMBRE;
  end loop;

  recorredor_arreglo := total_cooperativas.FIRST;

  while recorredor_arreglo IS NOT NULL loop

    if(cooperativas_ocupadas.EXISTS(recorredor_arreglo) = FALSE) then
      DBMS_OUTPUT.PUT_LINE(contador_impresor2||'. '||total_cooperativas(recorredor_arreglo));
      contador_impresor2 := contador_impresor2 + 1;
    end if;

    recorredor_arreglo := total_cooperativas.NEXT(recorredor_arreglo);
  end loop;

  DBMS_OUTPUT.PUT_LINE('}');

  exception
  when OTHERS then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||SQLCODE);

end;
/