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