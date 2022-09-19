-- Borrar los datos que hayan en las tablas
DELETE COOPEXSOCIO;
DELETE COOPERATIVA;
DELETE SOCIO;
-- Ver los datos que hayan en las tablas
SELECT * FROM COOPERATIVA;
SELECT * FROM SOCIO;
SELECT * FROM COOPEXSOCIO;
-- Casos de prueba Cooperativa
INSERT INTO cooperativa VALUES (1, 'Faithless', NULL);
INSERT INTO cooperativa VALUES (4, 'El Cerdito', 453);
INSERT INTO cooperativa VALUES (5, 'Su Vaquita', NULL);
-- Casos de prueba Socio
INSERT INTO socio VALUES (50, 'Rhianna Kenny', NULL);
INSERT INTO socio VALUES (60, 'Kyla La Grange', 4534);
INSERT INTO socio VALUES (99, 'Cass Fox', NULL);
-- Casos de prueba Coopexsocio
INSERT INTO coopexsocio VALUES (50, 1, NULL);
INSERT INTO coopexsocio VALUES (60, 1, NULL);
INSERT INTO coopexsocio VALUES (99, 1, 453);
INSERT INTO coopexsocio VALUES (60, 5, 345354);
INSERT INTO coopexsocio VALUES (99, 5, NULL);
-- Caso de prueba updateTriggerCoop
UPDATE COOPERATIVA SET C_ACUMULADO = C_ACUMULADO + 100 WHERE CODIGO = 1;
UPDATE COOPERATIVA SET C_ACUMULADO = C_ACUMULADO + 60 WHERE CODIGO = 5;
-- Casos de prueba deleteCoopTrigger
DELETE FROM COOPERATIVA WHERE CODIGO = 1;
-- Casos de prueba deleteSocioTrigger
DELETE FROM SOCIO WHERE IDSOCIO = 99;

-- casos extra

-- socio que no esta en ninguna cooperativa
INSERT INTO socio VALUES (400, 'Bergoglio', NULL);
-- socio que esta en todas las cooperativas
INSERT INTO socio VALUES (69, 'Orozco', NULL);
INSERT INTO coopexsocio VALUES (69, 1, NULL);
INSERT INTO coopexsocio VALUES (69, 4, NULL);
INSERT INTO coopexsocio VALUES (69, 5, NULL);
-- Casos de prueba
-- programa1
begin
  PROGRAM.UNO(1);
  PROGRAM.UNO(4);
  PROGRAM.UNO(5);
end;
-- programa2
begin
  PROGRAM.DOS(99);
  PROGRAM.DOS(60);
  PROGRAM.DOS(50);
  PROGRAM.DOS(400);
  PROGRAM.DOS(69);
end;
