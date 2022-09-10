CREATE OR REPLACE TRIGGER controlInsertCoopexsocio
BEFORE INSERT ON COOPEXSOCIO
FOR EACH ROW
begin

  if (:NEW.sc_acumulado IS NULL) or (:NEW.sc_acumulado != 0) then
    :NEW.sc_acumulado := 0;
  end if;

  exception
  when OTHERS then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);

end;