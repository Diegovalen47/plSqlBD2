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

-- incremento a cooperartiva sin socios
UPDATE COOPERATIVA SET C_ACUMULADO = C_ACUMULADO + 70 WHERE CODIGO = 4;

-- Casos de prueba
-- programa1
begin
  PROGRAM.UNO(19);
  PROGRAM.UNO(11);
  PROGRAM.UNO(15);
  PROGRAM.UNO(17);
end;
-- programa2
begin
  PROGRAM.DOS(407);
  PROGRAM.DOS(930);
  PROGRAM.DOS(5600);
  PROGRAM.DOS(7080);
  PROGRAM.DOS(3905);
end;

UPDATE COOPERATIVA SET C_ACUMULADO = C_ACUMULADO + 67550000 WHERE CODIGO IN (1,
16,
17,
22,
48,
49,
50,
67,
76,
79,
83,
88,
98,
24,
81,
93,
7,
38,
20,
87
);


begin
--   EXTRA.FILLCOO(100);
--   EXTRA.FILLSOCIO(100);
  EXTRA.FILLCOOPEXSOCIO(20);
end;