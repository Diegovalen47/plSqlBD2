CREATE OR REPLACE TRIGGER controlDeletSocio
BEFORE DELETE ON SOCIO
FOR EACH ROW
begin
  -- borramos las filas de coopexsocio involucradas
  -- con el socio borrado
  DELETE FROM COOPEXSOCIO WHERE SOCIO = :OLD.IDSOCIO;

  exception
  when OTHERS then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);

end;