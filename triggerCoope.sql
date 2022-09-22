CREATE OR REPLACE TRIGGER triggerCoopeDML
BEFORE INSERT OR DELETE OR UPDATE
OF C_ACUMULADO ON COOPERATIVA
FOR EACH ROW
/*
 *   Trigger que se ejecuta antes de insertar, actualizar o borrar un registro de la tabla COOPERATIVA
 *   con la ayuda de If Insert, If Update y If Delete se puede determinar si se esta insertando, actualizando o borrando
 */
begin
  if INSERTING then
    begin
        /*
         *  Si se esta insertando un registro en la tabla COOPERATIVA
         *  se establece que el campo C_ACUMULADO sea igual a 0
         */
      if (:NEW.c_acumulado IS NULL) or (:NEW.c_acumulado != 0) then
        :NEW.c_acumulado := 0;
      end if;
    exception
      when OTHERS then
        DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
    end;
  end if;
  if DELETING then
      /*
       *  Si se esta borrando un registro en la tabla COOPERATIVA
       *  se decrementa el acumulado de los socios que participaron en la cooperativa
       *  en valor igual al que tenian en la cooperativa
       *  y se borra el registro de la tabla COOPERATIVA
       */
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
  end if;
  if UPDATING then
      /*
       * Si se esta actualizando un registro en la tabla COOPERATIVA
       * se actualiza el acumulado de los socios que participaron en la cooperativa
       * además no se permiten incrementos en el acumulado de la cooperativa negativos
       */
    declare
      -- Array para guardar registros de coopexsocio
      arrayCoopexsocio util.COOPEXSOCIOTYPE;

      incrementoTotal NUMBER(8);
      incrementoUnitario NUMBER(11,3);

      coopeCodigo NUMBER(8) := :NEW.CODIGO;

      INCREMENTO_NEGATIVO EXCEPTION;
      INCREMENTO_NULO EXCEPTION;

    begin
      incrementoTotal := :NEW.C_ACUMULADO - :OLD.C_ACUMULADO;
      if incrementoTotal > 0 then
        -- obtenemos socios que pertenecen a la cooperativa a actualizar
        SELECT SOCIO, COOPE, SC_ACUMULADO BULK COLLECT INTO arrayCoopexsocio
        FROM COOPEXSOCIO WHERE COOPE = coopeCodigo;
        incrementoUnitario := incrementoTotal/arrayCoopexsocio.COUNT;

        forall i in 1..arrayCoopexsocio.COUNT
          UPDATE SOCIO SET S_ACUMULADO = S_ACUMULADO + incrementoUnitario
          WHERE IDSOCIO = arrayCoopexsocio(i).SOCIO;

        forall i in 1..arrayCoopexsocio.COUNT
          UPDATE COOPEXSOCIO SET SC_ACUMULADO = SC_ACUMULADO + incrementoUnitario
          WHERE SOCIO = arrayCoopexsocio(i).SOCIO AND COOPE = coopeCodigo;

      elsif incrementoTotal = 0 then
        raise INCREMENTO_NULO;
      else
        raise INCREMENTO_NEGATIVO;
      end if;
    exception
      when INCREMENTO_NULO then
        DBMS_OUTPUT.PUT_LINE(SQLCODE|| ' No se incrementa nada');
      when INCREMENTO_NEGATIVO then
        DBMS_OUTPUT.PUT_LINE(SQLCODE|| ' Incremento negativo, por favor ingresa un incremento positivo');
        :NEW.C_ACUMULADO := :OLD.C_ACUMULADO;
      when ZERO_DIVIDE then
        DBMS_OUTPUT.PUT_LINE(SQLCODE|| ' La cooperativa ingresada no tiene socios');
      when OTHERS then
        DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||SQLCODE);
    end;
  end if;
end;