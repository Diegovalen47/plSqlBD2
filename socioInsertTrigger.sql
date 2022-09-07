CREATE OR REPLACE TRIGGER controlInsertSocio
BEFORE INSERT ON SOCIO
FOR EACH ROW
BEGIN
  IF (:NEW.s_acumulado is null) OR (:NEW.s_acumulado != 0) THEN
    :NEW.s_acumulado := 0;
  END IF;
END;