CREATE OR REPLACE TRIGGER triggerCoopeSocioDML
BEFORE INSERT ON COOPEXSOCIO
FOR EACH ROW
begin
  if (:new.sc_acumulado is null) or (:new.sc_acumulado != 0) then
    :new.sc_acumulado := 0;
  end if;
exception
  when others then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
end;