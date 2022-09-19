create or replace package program is
    procedure uno(codigoCoope IN COOPERATIVA.CODIGO%TYPE);
    procedure dos(codigoSocio IN SOCIO.IDSOCIO%TYPE);
end;

create or replace package body program is
    procedure uno(codigoCoope in COOPERATIVA.CODIGO%type) is
        nameCoope COOPERATIVA.NOMBRE%TYPE;
        cAcumulado COOPERATIVA.C_ACUMULADO%TYPE;
        cantSocios NUMBER(8);
        totalAcumulado  COOPEXSOCIO.SC_ACUMULADO%TYPE := 0;
        cont NUMBER(8) := 1;


        cursor header IS
        select NOMBRE, C2.SC_ACUMULADO from SOCIO S inner join COOPEXSOCIO C2 on S.IDSOCIO = C2.SOCIO where c2.COOPE = codigoCoope;

        begin
            select distinct nombre, C_ACUMULADO, count(*) into nameCoope, cAcumulado, cantSocios from COOPERATIVA inner join COOPEXSOCIO C2 on COOPERATIVA.CODIGO = C2.COOPE and c2.COOPE = codigoCoope group by nombre, C_ACUMULADO;
            DBMS_OUTPUT.PUT_LINE('Nombre de la cooperativa: ' ||nameCoope);
            DBMS_OUTPUT.PUT_LINE('Acumulado de la cooperativa: ' ||cAcumulado);
            DBMS_OUTPUT.PUT_LINE('Número de socios: ' ||cantSocios);
            DBMS_OUTPUT.PUT_LINE('Socios de la cooperativa: ');
            DBMS_OUTPUT.PUT_LINE('{');
            for i in header loop
                DBMS_OUTPUT.PUT_LINE(cont||'. (Nombre: '||i.NOMBRE||', Valorsc: '||i.SC_ACUMULADO||')');
                totalAcumulado := totalAcumulado + i.SC_ACUMULADO;
                cont := cont + 1;
            end loop;
            DBMS_OUTPUT.PUT_LINE('}');
            DBMS_OUTPUT.PUT_LINE('Total valores de los socios en la cooperativa: '||totalAcumulado);

            exception
                when NO_DATA_FOUND then
                    DBMS_OUTPUT.PUT_LINE(SQLCODE||' La Cooperativa ingresada no existe');
                when others then
                    DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
        end;
    procedure dos(codigoSocio in SOCIO.idsocio%type) is
        nameSocio socio.nombre%type;
        sAcumulado socio.s_acumulado%type;
        cantCoope NUMBER(8);
        cont NUMBER(8) := 1;
        cursor header is
        select C4.NOMBRE, C3.SC_ACUMULADO from COOPERATIVA C4 inner join COOPEXSOCIO C3 on C4.CODIGO = C3.COOPE where c3.SOCIO = codigoSocio;

        cursor footer is
        select NOMBRE from cooperativa left join COOPEXSOCIO C2 on COOPERATIVA.CODIGO = C2.COOPE and C2.SOCIO = codigoSocio where SOCIO is null;
        begin
            select distinct s.NOMBRE, s.S_ACUMULADO, count(*) into nameSocio, sAcumulado, cantCoope from socio s inner join COOPEXSOCIO C2 on s.IDSOCIO = C2.SOCIO and c2.SOCIO = codigoSocio group by NOMBRE, S_ACUMULADO;
            DBMS_OUTPUT.PUT_LINE('Nombre del socio: ' ||nameSocio);
            DBMS_OUTPUT.PUT_LINE('Acumulado del socio: ' ||sAcumulado);
            DBMS_OUTPUT.PUT_LINE('Número de cooperativas en las que participa: ' ||cantCoope);
            DBMS_OUTPUT.PUT_LINE('Cooperativas del socio: ');
            DBMS_OUTPUT.PUT_LINE('{');
            for i in header loop
                DBMS_OUTPUT.PUT_LINE(cont||'. (Nombre: '||i.NOMBRE||', Valorsc: '||i.SC_ACUMULADO||')');
                cont := cont + 1;
            end loop;
            cont := 1;
            DBMS_OUTPUT.PUT_LINE('{');
            DBMS_OUTPUT.PUT_LINE('Cooperativas en las que no está el socio: ');
            for i in footer loop
                DBMS_OUTPUT.PUT_LINE(cont||'. '||i.NOMBRE);
                cont := cont + 1;
            end loop;
            DBMS_OUTPUT.PUT_LINE('}');
            exception
                when NO_DATA_FOUND then
                    DBMS_OUTPUT.PUT_LINE(SQLCODE||' El socio ingresado no existe');
                when others then
                    DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
        end;
end;
