create or replace trigger triggerSocioDML before insert or delete on SOCIO for each row
    begin
        if inserting then
            begin
                if (:new.s_acumulado IS NULL) or (:new.s_acumulado != 0) then
                    :new.s_acumulado := 0;
                end if;
                exception
                    when others then
                    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
            end;
        end if;
        if deleting then
            begin
                delete from COOPEXSOCIO where SOCIO = :old.IDSOCIO;
                exception
                    when others then
                    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
            end;
        end if;
    end;
