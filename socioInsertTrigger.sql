CREATE OR REPLACE TRIGGER controlInsertSocio
BEFORE INSERT ON SOCIO
FOR EACH ROW
begin

  if (:NEW.s_acumulado IS NULL) or (:NEW.s_acumulado != 0) then
    :NEW.s_acumulado := 0;
  end if;

exception
  when OTHERS then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
end;
/