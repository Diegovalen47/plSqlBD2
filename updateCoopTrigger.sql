CREATE OR REPLACE TRIGGER controlUpdateCoop
BEFORE UPDATE OF C_ACUMULADO ON COOPERATIVA
FOR EACH ROW
declare
  -- Array para guardar registros de coopexsocio
  arrayCoopexsocio util.COOPEXSOCIOTYPE;

  incrementoTotal NUMBER(8);
  incrementoUnitario NUMBER(11,3);

  coopeCodigo NUMBER(8) := :OLD.CODIGO;

  INCREMENTO_NEGATIVO EXCEPTION;
  INCREMENTO_NULO EXCEPTION;

begin

  incrementoTotal := :NEW.C_ACUMULADO - :OLD.C_ACUMULADO;

  if incrementoTotal > 0 then
    -- obtenemos socios que pertenecen a la cooperativa a actualizar
    SELECT SOCIO, COOPE, SC_ACUMULADO BULK COLLECT INTO arrayCoopexsocio
    FROM COOPEXSOCIO WHERE COOPE = coopeCodigo;

    incrementoUnitario := incrementoTotal/arrayCoopexsocio.COUNT;

    forall i in 1..arrayCoopexsocio.COUNT
      UPDATE SOCIO SET S_ACUMULADO = S_ACUMULADO + incrementoUnitario
      WHERE IDSOCIO = arrayCoopexsocio(i).SOCIO;

    forall i in 1..arrayCoopexsocio.COUNT
      UPDATE COOPEXSOCIO SET SC_ACUMULADO = SC_ACUMULADO + incrementoUnitario
      WHERE SOCIO = arrayCoopexsocio(i).SOCIO AND COOPE = coopeCodigo;

  elsif incrementoTotal = 0 then
    raise INCREMENTO_NULO;
  else
    raise INCREMENTO_NEGATIVO;

  end if;

  exception
  when INCREMENTO_NULO then
    DBMS_OUTPUT.PUT_LINE(SQLERRM|| ' No se incrementa nada');
  when INCREMENTO_NEGATIVO then
    DBMS_OUTPUT.PUT_LINE(SQLERRM|| ' Incremento negativo, por favor ingresa un incremento positivo');
    :NEW.C_ACUMULADO := :OLD.C_ACUMULADO;
  when ZERO_DIVIDE then
    DBMS_OUTPUT.PUT_LINE(SQLERRM|| ' La cooperativa ingresada no tiene socios');
    :NEW.C_ACUMULADO := :OLD.C_ACUMULADO;
  when OTHERS then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||SQLCODE);

end;
/