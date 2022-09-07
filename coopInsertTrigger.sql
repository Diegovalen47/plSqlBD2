CREATE OR REPLACE TRIGGER controlInsertCooperativa
BEFORE INSERT ON COOPERATIVA
FOR EACH ROW
BEGIN
  IF (:NEW.c_acumulado is null) OR (:NEW.c_acumulado != 0) THEN
    :NEW.c_acumulado := 0;
  END IF;
END;