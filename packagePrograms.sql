
CREATE OR REPLACE PACKAGE program IS
    /*
     *   Este es un paquete que contiene el código de la solucion del programa 1 y 2
     */
  PROCEDURE uno(codigoCoope IN COOPERATIVA.CODIGO%TYPE);
  PROCEDURE dos(codigoSocio IN SOCIO.IDSOCIO%TYPE);
end;

CREATE OR REPLACE PACKAGE BODY program IS

  PROCEDURE uno(codigoCoope in COOPERATIVA.CODIGO%type) IS
    /*
     *  Este procedimiento recibe el codigo de una cooperativa y muestra el nombre de la cooperativa, el acumulado,
     *  número de socios y nombre de los socios que pertenecen a ella asi como el total de los aportes de cada socio
     *  y el total de todos ellos
     *
     *  @param codigoCoope: Código de la cooperativa que ingresa el usuario
     */
    nameCoope COOPERATIVA.NOMBRE%TYPE;
    cAcumulado COOPERATIVA.C_ACUMULADO%TYPE;
    cantSocios NUMBER(8);
    totalAcumulado  COOPEXSOCIO.SC_ACUMULADO%TYPE := 0;
    cont NUMBER(8) := 1;

    cursor header IS
      SELECT S.NOMBRE, C2.SC_ACUMULADO
      FROM SOCIO S JOIN COOPEXSOCIO C2 ON S.IDSOCIO = C2.SOCIO
      WHERE C2.COOPE = codigoCoope;

    begin

      begin
        SELECT DISTINCT C1.NOMBRE, C1.C_ACUMULADO, COUNT(*)
        INTO nameCoope, cAcumulado, cantSocios
        FROM COOPERATIVA C1 INNER JOIN COOPEXSOCIO C2 ON C1.CODIGO = C2.COOPE AND C2.COOPE = codigoCoope
        GROUP BY NOMBRE, C_ACUMULADO;
      exception
        when NO_DATA_FOUND then
          SELECT NOMBRE, C_ACUMULADO
          INTO nameCoope, cAcumulado
          FROM COOPERATIVA
          WHERE CODIGO = codigoCoope;
          cantSocios := 0;
      end;

      DBMS_OUTPUT.PUT_LINE(' ');
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

  PROCEDURE dos(codigoSocio in SOCIO.idsocio%type) IS
      /*
       *  Este procedimiento recibe el codigo de un socio y muestra el nombre del socio, el acumulado,
       *  número de cooperativas y nombre de las cooperativas a las que pertenece asi como el total que tiene en cada cooperativa
       *  y todas las cooperativas en las que no participa
       *
       *  @param codigoSocio: Código del socio que ingresa el usuario
       *
       */
    nameSocio socio.NOMBRE%type;
    sAcumulado socio.S_ACUMULADO%type;
    cantCoope NUMBER(8);
    cont NUMBER(8) := 1;

    cursor header is
      SELECT C4.NOMBRE, C3.SC_ACUMULADO
      FROM COOPERATIVA C4 INNER JOIN COOPEXSOCIO C3 ON C4.CODIGO = C3.COOPE
      WHERE C3.SOCIO = codigoSocio;

    cursor footer is
      SELECT C1.NOMBRE
      FROM COOPERATIVA C1
      LEFT JOIN COOPEXSOCIO C2 ON C1.CODIGO = C2.COOPE AND C2.SOCIO = codigoSocio
      WHERE SOCIO IS NULL;

    begin

      begin
        SELECT DISTINCT S.NOMBRE, S.S_ACUMULADO, count(*)
        INTO nameSocio, sAcumulado, cantCoope
        FROM SOCIO S INNER JOIN COOPEXSOCIO C2 ON S.IDSOCIO = C2.SOCIO AND C2.SOCIO = codigoSocio
        GROUP BY NOMBRE, S_ACUMULADO;
      exception
        when NO_DATA_FOUND then
          SELECT NOMBRE, S_ACUMULADO
          INTO nameSocio, sAcumulado
          FROM SOCIO
          WHERE IDSOCIO = codigoSocio;
          cantCoope := 0;
      end;

      DBMS_OUTPUT.PUT_LINE(' ');
      DBMS_OUTPUT.PUT_LINE('Nombre del socio: ' ||nameSocio);
      DBMS_OUTPUT.PUT_LINE('Acumulado del socio: ' ||sAcumulado);
      DBMS_OUTPUT.PUT_LINE('Número de cooperativas en las que participa: ' ||cantCoope);
      DBMS_OUTPUT.PUT_LINE('Cooperativas del socio: ');
      DBMS_OUTPUT.PUT_LINE('{');
      for i in header loop
        DBMS_OUTPUT.PUT_LINE(cont||'. (Nombre: '||i.NOMBRE||', Valorsc: '||i.SC_ACUMULADO||')');
        cont := cont + 1;
      end loop;
      DBMS_OUTPUT.PUT_LINE('}');
      cont := 1;
      DBMS_OUTPUT.PUT_LINE('Cooperativas en las que no está el socio: ');
      DBMS_OUTPUT.PUT_LINE('{');
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
