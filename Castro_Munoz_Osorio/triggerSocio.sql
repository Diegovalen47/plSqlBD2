CREATE OR REPLACE TRIGGER triggerSocioDML
BEFORE INSERT OR DELETE ON SOCIO
FOR EACH ROW
    /*
    *   Trigger que se ejecuta antes de insertar o borrar un registro de la tabla SOCIO
    *   con la ayuda de If Insert y If Delete se puede determinar si se esta insertando o borrando
    */
begin
  if INSERTING then
     /*
      *   Si se esta insertando un registro en la tabla SOCIO
      *   se establece que el campo S_ACUMULADO sea igual a 0
      */
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
     /*
      *   Si se esta borrando un registro en la tabla SOCIO
      *   se elimina el socio de la tabla COOPEXSOCIO primero
      *   y luego se borra el registro de la tabla SOCIO
      */
    begin
      DELETE FROM COOPEXSOCIO WHERE SOCIO = :old.IDSOCIO;
    exception
      when others then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
    end;
  end if;
end;
