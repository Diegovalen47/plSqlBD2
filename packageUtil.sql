CREATE OR REPLACE PACKAGE util IS

    -- Array de enteros
    TYPE arrayInt IS TABLE OF INTEGER INDEX BY BINARY_INTEGER;
    -- Array de strings
    TYPE arrayString IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
    -- Array de registos de socio
    TYPE socioType IS TABLE OF socio%ROWTYPE;

END;