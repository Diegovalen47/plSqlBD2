CREATE PROCEDURE programa2
(codigo_socio IN SOCIO.IDSOCIO%TYPE) IS
    nombre_socio SOCIO.NOMBRE%TYPE;
    acumulado_socio SOCIO.S_ACUMULADO%TYPE;
    cantidad_cooperativas NUMBER(8);
        BEGIN
            SELECT NOMBRE, S_ACUMULADO INTO nombre_socio, acumulado_socio FROM SOCIO WHERE IDSOCIO=codigo_socio;
            DBMS_OUTPUT.PUT_LINE('Nombre del socio: '||nombre_socio);
            IF(acumulado_socio IS NULL) THEN
                DBMS_OUTPUT.PUT_LINE('Acumulado del socio: '||'0');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Acumulado del socio: '||acumulado_socio);
            end if;
            select count(*) into cantidad_cooperativas from COOPEXSOCIO where SOCIO=codigo_socio;
            DBMS_OUTPUT.PUT_LINE('Número de cooperativas en las que participa: '||cantidad_cooperativas);
        END;
/