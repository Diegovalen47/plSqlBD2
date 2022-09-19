CREATE OR REPLACE TRIGGER triggerCoopeDML
BEFORE INSERT OR DELETE OR UPDATE
OF C_ACUMULADO ON COOPERATIVA
FOR EACH ROW
begin
  if INSERTING then
    begin
      DBMS_OUTPUT.PUT_LINE('as');
      if (:NEW.c_acumulado IS NULL) or (:NEW.c_acumulado != 0) then
        :NEW.c_acumulado := 0;
      end if;
    exception
      when OTHERS then
        DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
    end;
  end if;
  if DELETING then
    declare
      -- Array para guardar registros de coopexsocio
      arrayCoopexsocio util.COOPEXSOCIOTYPE;

      coopeCodigo NUMBER(8) := :OLD.CODIGO;

    begin
      DBMS_OUTPUT.PUT_LINE(coopeCodigo);
      DBMS_OUTPUT.PUT_LINE('ENTRE');
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
    declare
      -- Array para guardar registros de coopexsocio
      arrayCoopexsocio util.COOPEXSOCIOTYPE;

      incrementoTotal NUMBER(8);
      incrementoUnitario NUMBER(11,3);

      coopeCodigo NUMBER(8) := :NEW.CODIGO;

      INCREMENTO_NEGATIVO EXCEPTION;
      INCREMENTO_NULO EXCEPTION;

    begin
      DBMS_OUTPUT.PUT_LINE('ala');
      incrementoTotal := :NEW.C_ACUMULADO - :OLD.C_ACUMULADO;
      if :new.codigo != :old.codigo then
          DBMS_OUTPUT.PUT_LINE('ow');
      end if;
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
        :NEW.C_ACUMULADO := :OLD.C_ACUMULADO;
      when OTHERS then
        DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||SQLCODE);
    end;
  end if;
end;