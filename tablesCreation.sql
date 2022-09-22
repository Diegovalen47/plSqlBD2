/*
 * Creación de todas las tablas de la base de datos
 */

CREATE TABLE cooperativa (
  codigo NUMBER(8) PRIMARY KEY,
  nombre VARCHAR2(30) NOT NULL UNIQUE,
  c_acumulado NUMBER(8)
);

CREATE TABLE socio (
  idsocio NUMBER(8) PRIMARY KEY,
  nombre VARCHAR2(30) NOT NULL,
  s_acumulado NUMBER(11,3) CHECK(s_acumulado >= 0)
);

CREATE TABLE coopexsocio (
  socio NUMBER(8) REFERENCES socio,
  coope NUMBER(8) REFERENCES cooperativa,
  PRIMARY KEY(socio, coope),
  sc_acumulado NUMBER(11,3)
);

commit;