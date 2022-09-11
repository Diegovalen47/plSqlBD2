CREATE PROCEDURE programa2
(codigo_socio IN SOCIO.IDSOCIO%TYPE) IS
    nombre_socio SOCIO.NOMBRE%TYPE;
    acumulado_socio SOCIO.S_ACUMULADO%TYPE;
    cantidad_cooperativas NUMBER(8);
    contador_impresor1 NUMBER(8):=1;
    contador_impresor2 NUMBER(8):=1;
    CURSOR cooperativas_socio_programa2 IS SELECT * FROM COOPERATIVA INNER JOIN COOPEXSOCIO ON COOPERATIVA.CODIGO = COOPEXSOCIO.COOPE ;
    CURSOR cooperativas_all IS SELECT CODIGO, NOMBRE FROM COOPERATIVA;
    TYPE arreglito_string IS TABLE OF varchar2(20) INDEX BY BINARY_INTEGER;
    recorredor_arreglo NUMBER;
    cooperativas_ocupadas arreglito_string;
    total_cooperativas arreglito_string;
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
            DBMS_OUTPUT.PUT_LINE('Cooperativas del socio:');
            DBMS_OUTPUT.PUT_LINE('{');
            FOR RECORREDOR IN cooperativas_socio_programa2 LOOP
                IF(RECORREDOR.SOCIO=codigo_socio) THEN
                    IF(RECORREDOR.SC_ACUMULADO IS NULL) THEN
                        RECORREDOR.SC_ACUMULADO:=0;
                    end if;
                    DBMS_OUTPUT.PUT_LINE(contador_impresor1||'. '||'(Nombre: '||RECORREDOR.NOMBRE||', Valorsc: '||RECORREDOR.SC_ACUMULADO);
                    cooperativas_ocupadas(RECORREDOR.COOPE):= RECORREDOR.NOMBRE;
                    contador_impresor1:=contador_impresor1+1;
                end if;
                end loop;
            DBMS_OUTPUT.PUT_LINE('}');
            DBMS_OUTPUT.PUT_LINE('Cooperativas en las que no está el socio:');
            DBMS_OUTPUT.PUT_LINE('{');
            FOR RECORREDOR1 IN cooperativas_all LOOP
                total_cooperativas(RECORREDOR1.CODIGO):=RECORREDOR1.NOMBRE;
                end loop;


            recorredor_arreglo:=total_cooperativas.FIRST;

            WHILE recorredor_arreglo IS NOT NULL LOOP
                IF(cooperativas_ocupadas.EXISTS(recorredor_arreglo)=FALSE) THEN
                    DBMS_OUTPUT.PUT_LINE(contador_impresor2||'. '||total_cooperativas(recorredor_arreglo));
                    contador_impresor2:=contador_impresor2+1;
                end if;
              recorredor_arreglo:=total_cooperativas.NEXT(recorredor_arreglo);
                end loop;
            DBMS_OUTPUT.PUT_LINE('}');
        END;
/