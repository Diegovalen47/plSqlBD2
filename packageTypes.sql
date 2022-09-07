CREATE OR REPLACE PACKAGE util IS

  -- Array de enteros
  TYPE arrayInt IS TABLE OF INTEGER INDEX BY BINARY_INTEGER;
  -- Array de strings
  TYPE arrayString IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

  PROCEDURE fillSocio(numRows IN NUMBER);

  PROCEDURE fillCooperativa(numRows IN NUMBER);

END;

CREATE OR REPLACE PACKAGE BODY util IS

  PROCEDURE fillSocio(numRows IN NUMBER) AS

  sociosNames util.ARRAYSTRING;
  sociosLastNames util.ARRAYSTRING;
  cont NUMBER(4) := 0;

  begin

    --Nombres
    sociosNames(1) := 'Rhianna';
    sociosNames(2) := 'Kyla';
    sociosNames(3) := 'Cass';
    --Apellidos
    sociosLastNames(1) := 'Kenny';
    sociosLastNames(2) := 'La Grange';
    sociosLastNames(3) := 'Fox';

    while cont < numRows LOOP
      -- Bloque para controlar duplicados con exception
      begin

        INSERT INTO
          socio
        VALUES(
          ceil(DBMS_RANDOM.value(1, 10000)),
          sociosNames(ceil(DBMS_RANDOM.value(1, 3)))||' '||sociosLastNames(ceil(DBMS_RANDOM.value(1, 3))),
          ceil(DBMS_RANDOM.value(2, 4))
        );
        -- Obtenemos dinamicamente insertados hasta el momento
        SELECT COUNT(*) INTO cont FROM socio;
        -- controlamos indices duplicados
        exception
        when DUP_VAL_ON_INDEX then
          NULL;

      end;

    end loop;

  end;

  PROCEDURE fillCooperativa(numRows IN NUMBER) AS

  cooperativasNames util.ARRAYSTRING;
  cooperativasLastNames util.ARRAYSTRING;
  cont NUMBER(4) := 1;

  begin
    DBMS_OUTPUT.PUT_LINE('dadadad');
    --Nombres
    cooperativasNames(1) := 'Faithless';
    cooperativasNames(2) := 'El Cerdito';
    cooperativasNames(3) := 'Su Vaquita';
    --tipos de cooperativa
    cooperativasLastNames(1) := 'S.A.S';
    cooperativasLastNames(2) := 'S.A';
    cooperativasLastNames(3) := 'S.C.S';


    while cont <= numRows LOOP
      -- Bloque para controlar duplicados con exception
      begin
        DBMS_OUTPUT.PUT_LINE('dentro while');
        INSERT INTO
          cooperativa
        VALUES(
          cont,
          cooperativasNames(ceil(DBMS_RANDOM.value(1, 3)))||' '||cooperativasLastNames(ceil(DBMS_RANDOM.value(1, 3))),
          DBMS_RANDOM.value(2, 9)
        );
        cont := cont + 1;
        -- Obtenemos dinamicamente insertados hasta el momento
        SELECT COUNT(*) INTO cont FROM COOPERATIVA;
        -- controlamos indices duplicados
        exception
        when DUP_VAL_ON_INDEX then
          NULL;

      end;

    end loop;

  end;

END;