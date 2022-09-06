-- Procedimiento para llenar la tabla socio
CREATE OR REPLACE PROCEDURE fillSocio(numRows IN NUMBER) AS

  sociosNames types.ARRAYSTRING;
  sociosLastNames types.ARRAYSTRING;
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

begin
  fillSocio(5);
end;

SELECT * FROM socio;
delete socio;

-- Procedimiento para llenar la tabla cooperativa
CREATE OR REPLACE PROCEDURE fillCooperativa(numRows IN NUMBER) AS

  cooperativasNames types.ARRAYSTRING;
  cooperativasLastNames types.ARRAYSTRING;
  cont NUMBER(4) := 0;

begin
  DBMS_OUTPUT.PUT_LINE('dadadad');
  --Nombres
  cooperativasNames(1) := 'Faithless';
  cooperativasNames(2) := 'El Cerdito';
  cooperativasNames(3) := 'Su Vaquita';
  --Apellidos
  cooperativasLastNames(1) := 'S.A.S';
  cooperativasLastNames(2) := 'S.A';
  cooperativasLastNames(3) := 'S.C.S';


  while cont < numRows LOOP
    -- Bloque para controlar duplicados con exception
    begin
      DBMS_OUTPUT.PUT_LINE('dentro while');
      INSERT INTO
        cooperativa
      VALUES(
        ceil(DBMS_RANDOM.value(1, 10000)),
        cooperativasNames(ceil(DBMS_RANDOM.value(1, 3)))||' '||cooperativasLastNames(ceil(DBMS_RANDOM.value(1, 3))),
        ceil(DBMS_RANDOM.value(2, 4))
      );
      -- Obtenemos dinamicamente insertados hasta el momento
      SELECT COUNT(*) INTO cont FROM cooperativa;
      -- controlamos indices duplicados
      exception
      when DUP_VAL_ON_INDEX then
        NULL;

    end;

  end loop;

end;

begin
  fillCooperativa(5);
end;

SELECT * FROM cooperativa;
