CREATE OR REPLACE TRIGGER controlUpdateCoop
BEFORE UPDATE OF C_ACUMULADO ON COOPERATIVA
FOR EACH ROW
declare
  TYPE socioType IS TABLE OF socio%ROWTYPE;
  arraySocio socioType;
  incrementoTotal NUMBER(8);
  incrementoUnitario NUMBER(11,3);
  coopeCodigo NUMBER(8) := :OLD.CODIGO;
  INCREMENTO_NEGATIVO EXCEPTION;
  INCREMENTO_NULO EXCEPTION;
begin

  incrementoTotal := :NEW.C_ACUMULADO - :OLD.C_ACUMULADO;

  IF incrementoTotal > 0 THEN
    SELECT
      s.IDSOCIO,
      s.NOMBRE,
      s.S_ACUMULADO
    BULK COLLECT INTO
      arraySocio
    FROM
      SOCIO s JOIN COOPEXSOCIO cs
    ON
      s.IDSOCIO = cs.SOCIO
    WHERE
      cs.COOPE = :OLD.CODIGO
    ORDER BY s.IDSOCIO;

    incrementoUnitario := incrementoTotal/arraySocio.COUNT;

    FORALL i IN 1..arraySocio.COUNT
      UPDATE SOCIO SET S_ACUMULADO = S_ACUMULADO + incrementoUnitario WHERE IDSOCIO = arraySocio(i).IDSOCIO;

    FORALL i IN 1..arraySocio.COUNT
      UPDATE COOPEXSOCIO SET SC_ACUMULADO = SC_ACUMULADO + incrementoUnitario WHERE SOCIO = arraySocio(i).IDSOCIO AND COOPE = coopeCodigo;

  ELSIF incrementoTotal = 0 THEN
    RAISE INCREMENTO_NULO;
  ELSE
    RAISE INCREMENTO_NEGATIVO;

  end if;

  EXCEPTION
    WHEN INCREMENTO_NULO THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM|| ' No se incrementa nada');
    WHEN INCREMENTO_NEGATIVO THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM|| ' Incremento negativo, por favor ingresa un incremento positivo');
      :NEW.C_ACUMULADO := :OLD.C_ACUMULADO;
    WHEN ZERO_DIVIDE THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM|| ' La cooperativa ingresada no tiene socios');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM|| ' VIDA CATREHIJUEMALPARIDA');

end;