CREATE OR REPLACE PROCEDURE programa1(codigo_cooperativa IN COOPERATIVA.CODIGO%TYPE) IS

  nombre_cooperativa COOPERATIVA.NOMBRE%TYPE;
  acumulado_cooperativa COOPERATIVA.C_ACUMULADO%TYPE;
  cantidad_socios NUMBER(8);
  valor_scAcumulado_socios COOPEXSOCIO.SC_ACUMULADO%TYPE := 0;
  contador_impresor NUMBER(8) := 1;

  CURSOR socios_programa_1 IS
    SELECT *
    FROM SOCIO INNER JOIN COOPEXSOCIO
    ON SOCIO.IDSOCIO = COOPEXSOCIO.SOCIO;

begin

  SELECT NOMBRE, C_ACUMULADO
  INTO nombre_cooperativa, acumulado_cooperativa
  FROM COOPERATIVA
  WHERE CODIGO = codigo_cooperativa;

  DBMS_OUTPUT.PUT_LINE(' ');
  DBMS_OUTPUT.PUT_LINE('Nombre de la cooperativa: '||nombre_cooperativa);

  if(acumulado_cooperativa IS NULL) then
    DBMS_OUTPUT.PUT_LINE('Acumulado de la cooperativa: '||'0');
  else
    DBMS_OUTPUT.PUT_LINE('Acumulado de la cooperativa: '||acumulado_cooperativa);
  end if;

  SELECT count(*)
  INTO cantidad_socios
  FROM COOPEXSOCIO
  WHERE COOPE = codigo_cooperativa;

  DBMS_OUTPUT.PUT_LINE('Numero de socios: '||cantidad_socios);
  DBMS_OUTPUT.PUT_LINE('Socios de la cooperativa:');
  DBMS_OUTPUT.PUT_LINE('{');

  for recorredor in socios_programa_1 loop

    if (recorredor.COOPE = codigo_cooperativa) then

      if (recorredor.SC_ACUMULADO IS NULL) then
        recorredor.SC_ACUMULADO := 0;
        DBMS_OUTPUT.PUT_LINE(contador_impresor||'. (Nombre: '||recorredor.NOMBRE||', Valorsc: '||recorredor.SC_ACUMULADO||')');
      else
        DBMS_OUTPUT.PUT_LINE(contador_impresor||'. (Nombre: '||recorredor.NOMBRE||', Valorsc: '||recorredor.SC_ACUMULADO||')');
      end if;

      valor_scAcumulado_socios := valor_scAcumulado_socios+recorredor.SC_ACUMULADO;
      contador_impresor := contador_impresor + 1;

    end if;

  end loop;

  DBMS_OUTPUT.PUT_LINE('}');
  DBMS_OUTPUT.PUT_LINE('Total valores de los socios en la cooperativa: '||valor_scAcumulado_socios);

end;
/






