CREATE OR REPLACE TRIGGER triggerCoopeSocioDML
BEFORE INSERT ON COOPEXSOCIO
FOR EACH ROW
    /*
     * Trigger que se ejecuta antes de insertar un registro en la tabla COOPEXSOCIO
     */
begin
    /*
     *  Se establece que el campo SC_ACUMULADO se inserte con el valor 0
     */
  if (:new.sc_acumulado IS NULL) or (:new.sc_acumulado != 0) then
    :new.sc_acumulado := 0;
  end if;
exception
  when others then
    DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
end;