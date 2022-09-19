CREATE OR REPLACE PACKAGE extra IS

    PROCEDURE fillSocio(numRows In NUMBER);

    PROCEDURE fillCoo(numRows In NUMBER);

    PROCEDURE fillCoopexSocio(numRows In NUMBER);

END;
/

CREATE OR REPLACE PACKAGE BODY extra IS

  PROCEDURE fillSocio(numRows IN NUMBER) AS

    sociosNames util.ARRAYSTRING;
    sociosLastNames util.ARRAYSTRING;
    cont NUMBER(4) := 0;
  begin
    --Nombres
    sociosNames(1) := 'Rhianna';
    sociosNames(2) := 'Kyla';
    sociosNames(3) := 'Cass';
    sociosNames(4) := 'Tony';
    sociosNames(5) := 'Steve';
    sociosNames(6) := 'Bruce';
    sociosNames(7) := 'Natalia';
    sociosNames(8) := 'Wanda';
    sociosNames(9) := 'John';
    --Apellidos
    sociosLastNames(1) := 'Kenny';
    sociosLastNames(2) := 'La Grange';
    sociosLastNames(3) := 'Fox';
    sociosLastNames(4) := 'Stark';
    sociosLastNames(5) := 'Rogers';
    sociosLastNames(6) := 'Banner';
    sociosLastNames(7) := 'Romanova';
    sociosLastNames(8) := 'Maximoff';
    sociosLastNames(9) := 'Snow';

    while cont < numRows loop
      -- Bloque para controlar duplicados con exception
      begin

        INSERT INTO socio VALUES(
          ceil(DBMS_RANDOM.value(1, 10000)),
          sociosNames(ceil(DBMS_RANDOM.value(1, 9)))||' '||sociosLastNames(ceil(DBMS_RANDOM.value(1, 9))),
          ceil(DBMS_RANDOM.value(2, 4))
        );

        -- Obtenemos dinamicamente insertados hasta el momento
        SELECT COUNT(*) INTO cont FROM socio;
        -- controlamos indices duplicados
        exception
        when DUP_VAL_ON_INDEX then
          NULL;
        when others then
          DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
      end;
    end loop;
  end;

  PROCEDURE fillCoo(numRows IN NUMBER) IS

    nom util.ARRAYSTRING;
    lastNom util.ARRAYSTRING;
    names varchar2(100);

  begin
    -- Nombres de cooperativas
    nom(1) := 'Faithless';
    nom(2) := 'El Cerdito';
    nom(3) := 'Su Vaquita';
    nom(4) := 'Jhon F Kennedy';
    nom(5) := 'CooperNK';
    nom(6) := 'Milagritos';
    nom(7) := 'Cotrafa';
    nom(8) := 'CF de Antioquia';
    nom(9) := 'Sin ti';
    nom(10) := 'Las Americas';
    nom(11) := 'Confiar';
    nom(12) := 'Superate';
    --tipos de cooperativa
    lastNom(1) := 'S.A.S';
    lastNom(2) := 'S.A';
    lastNom(3) := 'S.C.S';
    lastNom(4) := 'Comanditas';
    lastNom(5) := 'L.T.D.A';
    lastNom(6) := 'Colectiva';
    lastNom(7) := 'Unipersonal';
    lastNom(7) := 'Anonima';

    for i in 1 .. numRows LOOP
      begin
        names := nom(ceil(DBMS_RANDOM.VALUE(1,12)))||' '||lastNom(ceil(DBMS_RANDOM.VALUE(1,7)));

        INSERT INTO COOPERATIVA
        VALUES(i,names,null);

        exception
        when DUP_VAL_ON_INDEX then
          DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
          DBMS_OUTPUT.PUT_LINE('Error con unique: '||names);
        when OTHERS then
          DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
      end;
    end loop;
  end;

    PROCEDURE fillCoopexSocio(numRows IN NUMBER) IS
        socio util.SOCIOTYPE;
        coope util.COOPETYPE;
        sizeSocio number;
        sizeCoope number;

        begin
            select * bulk collect into socio from SOCIO order by IDSOCIO;
            select * bulk collect into coope from COOPERATIVA order by CODIGO;
            sizeSocio := socio.COUNT;
            sizeCoope := coope.COUNT;
            for i in 1 .. numRows loop
                begin
                    insert into COOPEXSOCIO values (socio(ceil(DBMS_RANDOM.VALUE(1,sizeSocio))).idsocio,
                                                    COOPE(ceil(DBMS_RANDOM.VALUE(1,sizeSocio))).codigo
                                                    ,null);
                    exception
                        when DUP_VAL_ON_INDEX then
                            DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
                            DBMS_OUTPUT.PUT_LINE('Error con unique');
                        when OTHERS then
                            DBMS_OUTPUT.PUT_LINE(SQLERRM||' '||sqlcode);
                end;
            end loop;
        end;
END;
/