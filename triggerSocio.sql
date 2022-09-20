CREATE OR REPLACE TRIGGER triggerSocioDML
BEFORE INSERT OR DELETE ON SOCIO
FOR EACH ROW
begin
  if INSERTING then
    begin
      if (:new.s_acumulado IS NULL) or (:new.s_acumulado != 0) then
        :new.s_acumulado := 0;
      end if;
    exception
      when others then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
    end;
  end if;
  if DELETING then
    begin
      DELETE FROM COOPEXSOCIO WHERE SOCIO = :old.IDSOCIO;
    exception
      when others then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
    end;
  end if;
end;
