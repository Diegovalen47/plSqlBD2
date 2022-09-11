CREATE PROCEDURE programa1
(codigo_cooperativa IN COOPERATIVA.CODIGO%TYPE) IS
    nombre_cooperativa COOPERATIVA.NOMBRE%TYPE;
    acumulado_cooperativa COOPERATIVA.C_ACUMULADO%TYPE;
    cantidad_socios NUMBER(8);
    valor_scAcumulado_socios COOPEXSOCIO.SC_ACUMULADO%TYPE:=0;
    CURSOR socios_programa_1 IS SELECT * from SOCIO INNER JOIN COOPEXSOCIO ON SOCIO.IDSOCIO=COOPEXSOCIO.SOCIO;
    contador_impresor NUMBER(8):=1;
BEGIN
    SELECT NOMBRE, C_ACUMULADO INTO nombre_cooperativa,acumulado_cooperativa  FROM COOPERATIVA WHERE CODIGO=codigo_cooperativa;
    DBMS_OUTPUT.PUT_LINE('Nombre de la cooperativa: '||nombre_cooperativa);
    IF(acumulado_cooperativa IS NULL) THEN
        DBMS_OUTPUT.PUT_LINE('Acumulado de la cooperativa: '||'0');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Acumulado de la cooperativa: '||acumulado_cooperativa);
    END IF;
    SELECT count(*) INTO cantidad_socios FROM COOPEXSOCIO WHERE COOPE=codigo_cooperativa;
    DBMS_OUTPUT.PUT_LINE('Número de socios: '||cantidad_socios);
    DBMS_OUTPUT.PUT_LINE('Socios de la cooperativa:');
    DBMS_OUTPUT.PUT_LINE('{');
    FOR recorredor IN socios_programa_1 LOOP
        IF (recorredor.COOPE=codigo_cooperativa) THEN
            IF (recorredor.SC_ACUMULADO IS NULL) THEN
                recorredor.SC_ACUMULADO:=0;
                DBMS_OUTPUT.PUT_LINE(contador_impresor||'. (Nombre: '||recorredor.NOMBRE||', Valorsc: '||recorredor.SC_ACUMULADO||')');
            ELSE
                DBMS_OUTPUT.PUT_LINE(contador_impresor||'. (Nombre: '||recorredor.NOMBRE||', Valorsc: '||recorredor.SC_ACUMULADO||')');
            END IF;
            valor_scAcumulado_socios:=valor_scAcumulado_socios+recorredor.SC_ACUMULADO;
            contador_impresor:=contador_impresor+1;
        END IF;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('}');
    DBMS_OUTPUT.PUT_LINE('Total valores de los socios en la cooperativa: '||valor_scAcumulado_socios);
END;
/






