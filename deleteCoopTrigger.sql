CREATE OR REPLACE TRIGGER controlDeleteCoop
BEFORE DELETE ON COOPERATIVA
FOR EACH ROW
declare
  -- Array para guardar registros de coopexsocio
  arrayCoopexsocio util.COOPEXSOCIOTYPE;

  coopeCodigo NUMBER(8) := :OLD.CODIGO;

begin
  -- obtenemos socios que pertenecen a la cooperativa borrada
  SELECT SOCIO, COOPE, SC_ACUMULADO BULK COLLECT INTO arrayCoopexsocio
  FROM COOPEXSOCIO WHERE COOPE = coopeCodigo;

  -- decrementar sc_acumulado en tabla socio s_acumulado
  forall i in 1..arrayCoopexsocio.COUNT
    UPDATE SOCIO SET S_ACUMULADO = S_ACUMULADO - arrayCoopexsocio(i).SC_ACUMULADO
    WHERE IDSOCIO = arrayCoopexsocio(i).SOCIO;

  -- borrar esos socios de coopexsocio
  DELETE FROM COOPEXSOCIO WHERE COOPE = coopeCodigo;

exception
  when OTHERS then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
end;
/