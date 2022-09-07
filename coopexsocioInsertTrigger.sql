CREATE OR REPLACE TRIGGER controlInsertCoopexsocio
BEFORE INSERT ON COOPEXSOCIO
FOR EACH ROW
BEGIN
  IF (:NEW.sc_acumulado is null) OR (:NEW.sc_acumulado != 0) THEN
    :NEW.sc_acumulado := 0;
  END IF;
END;