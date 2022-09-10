CREATE OR REPLACE TRIGGER controlInsertCooperativa
BEFORE INSERT ON COOPERATIVA
FOR EACH ROW
begin

  if (:NEW.c_acumulado IS NULL) or (:NEW.c_acumulado != 0) then
    :NEW.c_acumulado := 0;
  end if;

  exception
  when OTHERS then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);

end;